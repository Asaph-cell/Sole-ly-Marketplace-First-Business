import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response(null, { headers: corsHeaders });
    }

    try {
        const supabaseClient = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
        );

        const { orderId, successUrl, cancelUrl } = await req.json();

        if (!orderId) {
            throw new Error('Order ID is required');
        }

        console.log(`Initiating IntraSend payment for order: ${orderId}`);

        // Fetch order and shipping details
        const { data: order, error: orderError } = await supabaseClient
            .from('orders')
            .select(`
        *,
        profiles:customer_id (email, full_name)
      `)
            .eq('id', orderId)
            .single();

        if (orderError || !order) {
            console.error('Order fetch error:', orderError);
            throw new Error('Order not found');
        }

        const { data: shipping, error: shippingError } = await supabaseClient
            .from('order_shipping_details')
            .select('*')
            .eq('order_id', orderId)
            .single();

        // Note: It's okay if shipping is missing or incomplete for some digital goods, 
        // but for e-commerce, it usually exists. We use optional chaining.

        // Prepare Customer Details
        const customerEmail = shipping?.email || order.profiles?.email || 'customer@solely.co.ke';
        const customerPhone = shipping?.phone || ''; // IntraSend requires phone usually, or optional.
        const customerName = shipping?.recipient_name || order.profiles?.full_name || 'Valued Customer';

        const [firstName, ...lastNameParts] = customerName.split(' ');
        const lastName = lastNameParts.join(' ') || firstName; // Fallback if single name

        // Payload for IntraSend Checkout API
        const payload = {
            public_key: Deno.env.get('INTRASEND_PUBLISHABLE_KEY'),
            amount: order.total_ksh,
            currency: "KES",
            email: customerEmail,
            phone_number: customerPhone,
            first_name: firstName,
            last_name: lastName,
            api_ref: orderId,
            redirect_url: successUrl || cancelUrl, // IntraSend only has one redirect_url generally? 
            // Actually, standard API has `redirect_url`. 
            // Using `successUrl` passed from frontend is best.
            method: "M-PESA", // Or leave empty for all. Let's leave empty to allow Card too.
        };

        // Remove method to allow all
        // @ts-ignore
        delete payload.method;

        console.log('Sending payload to IntraSend:', JSON.stringify({ ...payload, public_key: 'HIDDEN' }));

        const response = await fetch('https://payment.intasend.com/api/v1/checkout/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(payload),
        });

        const data = await response.json();

        if (!response.ok) {
            console.error('IntraSend Error:', data);
            throw new Error(`IntraSend API Error: ${JSON.stringify(data)}`);
        }

        if (!data.url) {
            console.error('No URL in response:', data);
            throw new Error('Failed to generate payment link');
        }

        console.log('Payment link generated:', data.url);

        return new Response(
            JSON.stringify({ success: true, url: data.url }),
            { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );

    } catch (error) {
        console.error('Error:', error);
        return new Response(
            JSON.stringify({ error: error.message }),
            { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
    }
});
