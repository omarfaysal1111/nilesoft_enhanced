

Nile Soft ERP - Erp integration 

Nile Soft ERP - ERP Integration App is a Flutter-based mobile application designed to manage and streamline the invoicing process. The app allows users to create, edit, and manage invoices efficiently, enhancing business operations with an intuitive and user-friendly interface.

Features
	•	Invoice Creation: Add multiple items to an invoice using a dynamic popup interface.
	•	Edit Items: Modify item details, including price, quantity, and discount, directly within the invoice.
	•	View Invoice Details: Display comprehensive invoice information in a structured format.
	•	Real-Time Calculations: Automatically calculate totals, discounts, and taxes while editing.
	•	Responsive Design: Fully optimized for various screen sizes.
	•	Arabic Support: Full RTL layout and Arabic text support for seamless user experience.

Tech Stack
	•	Framework: Flutter
	•	State Management: Provider
	•	Backend: REST API integration (assumes connection with Nile Soft ERP system)
	•	Language: Dart

Installation

Prerequisites
	•	Flutter SDK installed (Install Flutter)
	•	A configured REST API backend for invoice management

Steps
	1.	Clone the Repository:

git clone https://github.com/yourusername/nile-soft-invoice-app.git  
cd nile-soft-invoice-app  


	2.	Install Dependencies:

flutter pub get  


	3.	Configure API Endpoint:
	•	Update the API base URL in lib/constants/api_constants.dart.
	4.	Run the App:

flutter run  

Usage
	1.	Create an Invoice:
	•	Tap on the “New Invoice” button.
	•	Add items via the popup by specifying name, quantity, price, and discount.
	•	Save the invoice to calculate totals and view details.
	2.	Edit Invoice Items:
	•	Select an item from the invoice list.
	•	Modify item details and save changes.
	3.	View Invoice:
	•	Navigate to the invoice list to view all created invoices.
	•	Tap on any invoice to view detailed information.

Contribution

We welcome contributions!
	1.	Fork the repository.
	2.	Create a new branch:

git checkout -b feature-name  


	3.	Commit your changes:

git commit -m "Add feature"  


	4.	Push the branch:

git push origin feature-name  


	5.	Open a pull request.

License

This project is licensed under the MIT License. See the LICENSE file for more details.

Let me know if you need anything else added!