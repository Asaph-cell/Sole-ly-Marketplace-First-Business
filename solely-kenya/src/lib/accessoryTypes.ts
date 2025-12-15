// Predefined shoe accessory types for vendor listings

export const ACCESSORY_TYPES = [
    { name: "Suede Brush", key: "suede_brush" },
    { name: "Polish", key: "polish" },
    { name: "Foam Cleaner", key: "foam_cleaner" },
    { name: "Suede Renovator Spray/Oil", key: "suede_renovator" },
    { name: "Insoles", key: "insoles" },
    { name: "Heel Grips", key: "heel_grips" },
    { name: "Shoe Deodorizer", key: "shoe_deodorizer" },
    { name: "Shoe Cleaning Kit", key: "cleaning_kit" },
    { name: "Shoe Laces", key: "shoe_laces" },
] as const;

// Get accessory type name for display
export const getAccessoryTypeName = (key: string): string => {
    const type = ACCESSORY_TYPES.find(t => t.key.toLowerCase() === key.toLowerCase());
    return type?.name || key.charAt(0).toUpperCase() + key.slice(1).replace(/_/g, ' ');
};

// Check if an accessory type is valid
export const isValidAccessoryType = (key: string): boolean => {
    return ACCESSORY_TYPES.some(t => t.key.toLowerCase() === key.toLowerCase());
};
