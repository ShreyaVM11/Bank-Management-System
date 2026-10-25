# 🏦 Bank Management System

A Java Swing desktop application simulating an Automated Teller Machine (ATM) and bank account management system, backed by a MySQL database.

---

## 📋 Features

- **Account Registration (Multi-Step):**
  - Page 1: Personal details (Name, Father's Name, DOB via JCalendar, Gender, Address, etc.)
  - Page 2: Additional details (Religion, Category, Income, Education, PAN, Aadhaar)
  - Page 3: Account type selection (Savings, Current, Fixed Deposit, etc.) and automatic Card Number & PIN generation
- **Card & PIN Authentication:** Secure login screen matching credentials in MySQL
- **Main Transaction Dashboard:**
  - 💵 **Deposit:** Add funds to the account
  - 🏧 **Cash Withdrawal:** Withdraw funds with real-time balance checking
  - ⚡ **Fast Cash:** Quick pre-set withdrawal amounts (Rs 100, 500, 1000, 2000, 5000, 10000)
  - 📄 **Mini Statement:** View recent transaction history and card details
  - 🔑 **PIN Change:** Update the account PIN across the system
  - 📊 **Balance Enquiry:** Check available account balance

---

## 🛠️ Technology Stack

- **Language:** Java (JDK 17+)
- **GUI Framework:** Java Swing & AWT
- **Build Tool:** Apache Maven
- **Database:** MySQL 8.0+
- **JDBC Driver:** MySQL Connector/J 8.4.0
- **UI Components:** JCalendar 1.4

---

## ⚙️ Prerequisites

1. **Java Development Kit (JDK) 17 or higher**  
   Verify by running:
   ```bash
   java -version
   ```
2. **MySQL Server 8.0+** running locally (e.g., via MySQL Community Server, Workbench, or XAMPP).
3. *(Optional)* **Apache Maven 3.8+** (or open the project directly in IntelliJ IDEA / VS Code / NetBeans).

---

## 🚀 Quick Start & How to Run

### Option 1: One-Click Run (Windows)
Double-click `run.bat` or run in Command Prompt:
```cmd
run.bat
```
Or in PowerShell:
```powershell
.\run.ps1
```
*The launcher automatically detects your Java installation, sets up `.env` from template if missing, and launches the application.*

---

### Option 2: Using Maven
1. *(Optional)* Copy `.env.example` to `.env` and set your MySQL password if not blank:
   ```bash
   cp .env.example .env
   ```
2. Compile and launch:
   ```bash
   mvn clean compile
   mvn exec:java
   ```

---

### Option 3: Opening in an IDE (IntelliJ IDEA / Eclipse / VS Code)
1. Open the project folder in your IDE as a **Maven project**.
2. Maven will automatically download all dependencies (`mysql-connector-j` and `jcalendar`).
3. Locate `src/bank/management/system/Login.java`.
4. Right-click and select **Run 'Login.main()'**.

---

## 🗄️ Database Setup

The application features **automatic schema initialization** on first run:
- If the database `bankmanagementsystem` does not exist, it creates it automatically.
- If tables do not exist, it creates `signup`, `signup2`, `signup3`, `login`, and `bank` tables automatically.

If you prefer to set up the database manually:
1. Open MySQL Workbench or MySQL CLI.
2. Execute the script in [`database/schema.sql`](database/schema.sql):
   ```sql
   source database/schema.sql;
   ```

### Database Credentials Configuration
The application checks for credentials in the following order:
1. System environment variables (`DB_URL`, `DB_USER`, `DB_PASSWORD`)
2. JVM properties (`-DDB_USER=...`)
3. Local `.env` file (see `.env.example`)
4. Default fallback: `root` with blank password at `localhost:3306`

To set custom credentials in `.env`:
```ini
DB_URL=jdbc:mysql://localhost:3306/bankmanagementsystem
DB_USER=root
DB_PASSWORD=your_mysql_password
```

---

## 📁 Project Structure

```text
Bank-Management-System/
├── src/
│   ├── bank/management/system/      # Application source code
│   │   ├── BalanceEnquiry.java       # Balance checking screen
│   │   ├── Conn.java                 # Database connection & auto-table init
│   │   ├── Deposit.java              # Cash deposit screen
│   │   ├── FastCash.java             # Quick withdrawal screen
│   │   ├── Login.java                # Main entry point & login screen
│   │   ├── MiniStatement.java        # Mini statement display
│   │   ├── Pin.java                  # PIN change screen
│   │   ├── Signup.java               # Step 1 Registration
│   │   ├── Signup2.java              # Step 2 Additional Details
│   │   ├── Signup3.java              # Step 3 Account & Card Generation
│   │   ├── Transactions.java         # Main options menu
│   │   └── Withdrawl.java            # Standard withdrawal screen
│   └── icons/                        # ATM background and logo assets
├── database/
│   └── schema.sql                    # SQL database & table definitions
├── .env.example                      # Sample database configuration
├── .gitignore                        # Git ignore rules for build artifacts & secrets
├── pom.xml                           # Maven project configuration
├── run.bat                           # Windows batch launcher
├── run.ps1                           # Windows PowerShell launcher
└── README.md                         # Documentation
```

---

## 📤 Uploading to GitHub

To push this project to your GitHub account:

1. **Create a new empty repository** on GitHub (e.g., named `Bank-Management-System`). Do *not* initialize it with a README or `.gitignore` since they are already provided here.

2. In your terminal at the root of this project:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Bank Management System"
   git branch -M main
   git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/Bank-Management-System.git
   git push -u origin main
   ```

---

## 🔒 Security Notice

This project is built for educational and demonstration purposes. In production banking applications:
- PINs and passwords must be hashed using strong one-way cryptographic algorithms (e.g., BCrypt/Argon2).
- SQL statements should use parameterized `PreparedStatement` to prevent SQL injection.
- Database credentials must never be committed to public version control.
