-- Connect as the 'customer_role' user
-- Make sure to replace 'your_password' with the actual password for the 'customer_role' user
--CONNECT customer_role/your_password

-- Execute the stored procedure with sample values
set serveroutput on;
BEGIN WEBADMIN.insert_user(
        'Shreyas',
        'Naveen',
        'shreyas@gmail.com',
        'shreyas$456',
        '8572695113',
        'Customer',
        '199',
        'Parker Street',
        'Bostom',
        'MA',
        '02122'
    );
 WEBADMIN.insert_user(
        'Manish',
        'shivaprasad',
        'Manish@gmail.com',
        'manish$178',
        '8573761359',
        'Customer',
        '228',
        'South Street',
        'Boston',
        'MA',
        '02130'
    );
    
    
    WEBADMIN.insert_user(
    'John',
    'Doe',
    'john.doe@example.com',
    'john$123',
    '1234567890',
    'Customer',
    '101',
    'Main Street',
    'Cityville',
    'CA',
    '90210'
);

    WEBADMIN.insert_user(
    'Alice',
    'Johnson',
    'alice.j@example.com',
    'alice$456',
    '9876543210',
    'Customer',
    '304',
    'Oak Avenue',
    'Townsville',
    'NY',
    '10001'
);


WEBADMIN.insert_user(
    'Chris',
    'Smith',
    'chris.smith@example.com',
    'chris$789',
    '5551234567',
    'Customer',
    '512',
    'Pine Street',
    'Villagetown',
    'TX',
    '75001'
);

    
WEBADMIN.insert_user(
        'Apple',
        'inc',
        'apple@gmail.com',
        'apple9078',
        '9113992184',
        'seller',
        '2147',
        'apple bouleyard',
        'san jose',
        'CA',
        '95050'
    );
 WEBADMIN.insert_user(
        'Zara',
        'Fashion',
        'zara@gmail.com',
        'zara#1256',
        '8573451243',
        'seller',
        '203',
        'huntintgon ave',
        'Boston',
        'MA',
        '02130'
    );
    
    WEBADMIN.insert_user(
    'TechGadgets',
    'Ltd',
    'techgadgets@example.com',
    'tech1234',
    '9876543210',
    'seller',
    '1023',
    'Gadget Street',
    'Tech City',
    'CA',
    '90210'
);


WEBADMIN.insert_user(
    'FashionHub',
    'Corp',
    'fashionhub@example.com',
    'fashion5678',
    '5556789012',
    'seller',
    '789',
    'Fashion Avenue',
    'Styletown',
    'NY',
    '10001'
);

WEBADMIN.insert_user(
    'HomeEssentials',
    'LLC',
    'homeessentials@example.com',
    'home1234',
    '1234567890',
    'seller',
    '456',
    'Essential Street',
    'Homestead',
    'TX',
    '75001'
);

    
 WEBADMIN.insert_user(
        'Fedex',
        'Express',
        'fedex@gmail.com',
        'fedex!235',
        '8672151567',
        'Shipper',
        '34',
        'summer st',
        'new york',
        'NY',
        '959071'
    );
 WEBADMIN.insert_user(
        'UPS',
        'Logistics',
        'UPS@gmail.com',
        'UPS9078',
        '9119012890',
        'Shipper',
        '29',
        'centre st',
        'Boston',
        'MA',
        '02130'
    );
    
    WEBADMIN.insert_user(
    'DHL',
    'Express',
    'dhlexpress@example.com',
    'dhl5678',
    '5556789012',
    'Shipper',
    '789',
    'Express Avenue',
    'Shippingtown',
    'NY',
    '10001'
);


WEBADMIN.insert_user(
    'Amazon',
    'Shipping',
    'amazonshipping@example.com',
    'amazon1234',
    '1234567890',
    'Shipper',
    '456',
    'Shipping Street',
    'Amazontown',
    'TX',
    '75001'
);

    
END;
/

