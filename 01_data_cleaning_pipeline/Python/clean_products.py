"""
Project: Restaurant Online Orders - Data Cleaning Script
Author: Vincenzo Di Sario
Date: November 2025
---------------------------------------------------------
🎯 Purpose:
This script cleans and restructures raw order data exported from the
restaurant's online delivery platform ("Last").

Each row in the original Excel file represents a single invoice.
Inside the 'products' column, all items purchased in the same order
are listed in one text string, separated by semicolons.

Example raw data:
---------------------------------------------------------
invoice_no | products
---------------------------------------------------------
LS35713 | 1x Butter Naan.;
           1x Samosa 1 Unidad.: 1x Sin Salsa Extra, 1x Samosa 1 unidad (vegano);
           1x Pollo Tikka Masala. : 1x Arroz al Zeera Vegano., 1x Pollo Tikka Masala;
           1x Menú Mayura.: 1x Cerveza Moritz, lata 0,33l., 1x Naan., 1x Lassi de Mango.
---------------------------------------------------------

⚙️ Objective:
Transform this unstructured text into a clean, tabular format
with one product per row, ready for SQL and Power BI analysis.

Expected output structure:
---------------------------------------------------------
transaction_id | invoice_no | quantity | product
---------------------------------------------------------
1              | LS35713    | 1        | Butter Naan
2              | LS35713    | 1        | Samosa 1 Unidad
3              | LS35713    | 1        | Pollo Tikka Masala
---------------------------------------------------------
"""

# === Import libraries ===
import pandas as pd
import re

# === 1. Load the Excel file ===
# The file should be located in the same folder as this script.
# Columns required: 'invoice_no' and 'products'
df = pd.read_excel("products.xlsx")

# === 2. Prepare a list to collect cleaned product rows ===
clean_rows = []

# === 3. Iterate through each invoice (each order row) ===
for _, row in df.iterrows():
    invoice_no = row["invoice_no"]
    raw_text = str(row["products"])

    # Split the string by semicolon to separate each product
    products = [p.strip() for p in raw_text.split(";") if p.strip()]

    for product in products:
        # Remove any modifiers (everything after ":")
        # Example: "1x Samosa 1 Unidad.: 1x Sin Salsa Extra..." -> "1x Samosa 1 Unidad."
        product = product.split(":")[0].strip()

        # Extract quantity using regex (e.g., "2x" or "1x")
        match = re.match(r"(\d+)x\s*(.*)", product)
        if match:
            quantity = int(match.group(1))
            product_name = match.group(2)
        else:
            # If no explicit quantity is found, assume 1
            quantity = 1
            product_name = product

        # Clean the product name: remove dots, asterisks, quotes, etc.
        product_name = re.sub(r"[\*\.\"]", "", product_name).strip()

        # Append the cleaned information to the list
        clean_rows.append({
            "invoice_no": invoice_no,
            "quantity": quantity,
            "product": product_name
        })

# === 4. Create a new DataFrame from the cleaned rows ===
clean_df = pd.DataFrame(clean_rows)

# === 5. Add a unique transaction ID ===
# This gives each product line a unique identifier
clean_df.reset_index(inplace=True)
clean_df.rename(columns={"index": "transaction_id"}, inplace=True)
clean_df["transaction_id"] = clean_df["transaction_id"] + 1  # start IDs at 1

# === 6. Save the cleaned data to CSV ===
# Output: clean_products.csv (ready for SQL import or Power BI)
clean_df.to_csv("clean_products.csv", index=False, encoding="utf-8-sig")

# === 7. Print confirmation and sample preview ===
print("✅ Clean file created successfully: clean_products.csv")
print("Preview of cleaned data:")
print(clean_df.head(10))
