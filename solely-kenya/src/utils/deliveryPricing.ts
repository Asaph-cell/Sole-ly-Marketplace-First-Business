/**
 * Smart Delivery Pricing Utility
 * Calculates delivery fees based on vendor and buyer locations using metro area logic
 */

// Metro area groupings for Kenya
const METRO_AREAS = {
    nairobi: ['Nairobi', 'Kiambu', 'Machakos', 'Kajiado'],
    mombasa: ['Mombasa', 'Kilifi'],
    kisumu: ['Kisumu'],
    nakuru: ['Nakuru'],
    eldoret: ['Uasin Gishu'],
} as const;

// Major cities for inter-city pricing
const MAJOR_CITIES = [
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Nakuru',
    'Eldoret',
    'Kiambu',
    'Machakos',
    'Kajiado',
    'Kilifi',
    'Uasin Gishu',
] as const;

/**
 * Delivery fee tiers (in KES)
 */
export const DELIVERY_FEES = {
    SAME_METRO: 200, // Same metro area (e.g., Nairobi → Kiambu)
    INTER_CITY: 400, // Different major cities (e.g., Nairobi → Mombasa)
    DISTANT: 500, // To/from smaller towns (e.g., Nairobi → Garissa)
    PICKUP: 0, // Pickup orders
} as const;

/**
 * Get metro area for a given county
 */
function getMetroArea(county?: string | null): string | null {
    if (!county) return null;

    const normalizedCounty = county.trim();

    for (const [metroName, counties] of Object.entries(METRO_AREAS)) {
        if (counties.some(c => normalizedCounty.toLowerCase().includes(c.toLowerCase()))) {
            return metroName;
        }
    }

    return null;
}

/**
 * Check if a county is in a major city/metro area
 */
function isMajorCity(county?: string | null): boolean {
    if (!county) return false;

    const normalizedCounty = county.trim().toLowerCase();
    return MAJOR_CITIES.some(city => normalizedCounty.includes(city.toLowerCase()));
}

/**
 * Calculate delivery fee based on vendor and buyer locations
 * 
 * Logic:
 * 1. If same metro area → KES 200
 * 2. If both are major cities but different metros → KES 400
 * 3. Otherwise (one or both in smaller towns) → KES 500
 * 4. Pickup orders → KES 0
 */
export function calculateDeliveryFee(params: {
    vendorCounty?: string | null;
    buyerCounty?: string | null;
    isPickup?: boolean;
}): number {
    const { vendorCounty, buyerCounty, isPickup } = params;

    // Pickup orders have no delivery fee
    if (isPickup) {
        return DELIVERY_FEES.PICKUP;
    }

    // If vendor location is not set, fall back to old logic
    // (Nairobi = 200, Outside = 300)
    if (!vendorCounty) {
        // Legacy fallback: check if buyer is in Nairobi
        const buyerMetro = getMetroArea(buyerCounty);
        return buyerMetro === 'nairobi' ? 200 : 300;
    }

    // Get metro areas for both parties
    const vendorMetro = getMetroArea(vendorCounty);
    const buyerMetro = getMetroArea(buyerCounty);

    // Same metro area → KES 200
    if (vendorMetro && buyerMetro && vendorMetro === buyerMetro) {
        return DELIVERY_FEES.SAME_METRO;
    }

    // Both are major cities but different metros → KES 400
    const vendorIsMajor = isMajorCity(vendorCounty);
    const buyerIsMajor = isMajorCity(buyerCounty);

    if (vendorIsMajor && buyerIsMajor) {
        return DELIVERY_FEES.INTER_CITY;
    }

    // One or both in smaller towns → KES 500
    return DELIVERY_FEES.DISTANT;
}

/**
 * Get zone information for display purposes
 */
export function getDeliveryZoneInfo(params: {
    vendorCounty?: string | null;
    buyerCounty?: string | null;
    isPickup?: boolean;
}): {
    zone: 1 | 2 | 3 | null;
    fee: number;
    description: string;
} {
    const { vendorCounty, buyerCounty, isPickup } = params;

    if (isPickup) {
        return {
            zone: null,
            fee: DELIVERY_FEES.PICKUP,
            description: 'Pickup - No delivery fee',
        };
    }

    const fee = calculateDeliveryFee({ vendorCounty, buyerCounty, isPickup });

    if (fee === DELIVERY_FEES.SAME_METRO) {
        return {
            zone: 1,
            fee,
            description: 'Same metro area delivery',
        };
    }

    if (fee === DELIVERY_FEES.INTER_CITY) {
        return {
            zone: 2,
            fee,
            description: 'Inter-city delivery',
        };
    }

    return {
        zone: 3,
        fee,
        description: 'Distant delivery',
    };
}
