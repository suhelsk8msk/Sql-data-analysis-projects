CREATE TABLE Customer (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15),
    PasswordHash VARCHAR(255),
    DateOfBirth DATE,
    RegistrationDate DATE DEFAULT CURRENT_DATE,
    PrimeMember BOOLEAN,
    AccountStatus VARCHAR(20)
);

CREATE TABLE Seller (
    SellerID SERIAL PRIMARY KEY,
    BusinessName VARCHAR(100),
    OwnerName VARCHAR(100),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    GSTNumber VARCHAR(20),
    BusinessAddress TEXT,
    RegistrationDate DATE,
    SellerRating DECIMAL(2,1),
    SellerStatus VARCHAR(20)
);

CREATE TABLE Category (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100),
    Description TEXT,
    ParentCategoryID INT,
    FOREIGN KEY (ParentCategoryID)
        REFERENCES Category(CategoryID)
);

CREATE TABLE Product (
    ProductID SERIAL PRIMARY KEY,
    SellerID INT,
    CategoryID INT,
    ProductName VARCHAR(150),
    Brand VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10,2),
    DiscountPercentage DECIMAL(5,2),
    Weight DECIMAL(8,2),
    Color VARCHAR(50),
    Size VARCHAR(50),
    Warranty VARCHAR(100),
    ImageURL TEXT,
    AverageRating DECIMAL(2,1),
    CreatedDate DATE,
    FOREIGN KEY (SellerID)
        REFERENCES Seller(SellerID),
    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
);

CREATE TABLE Inventory (
    InventoryID SERIAL PRIMARY KEY,
    ProductID INT NOT NULL,
    WarehouseLocation VARCHAR(100),
    AvailableStock INT NOT NULL,
    ReservedStock INT DEFAULT 0,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);


CREATE TABLE ShoppingCart (
    CartID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CartStatus VARCHAR(20),

    CONSTRAINT fk_cart_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
);

CREATE TABLE CartItem (
    CartItemID SERIAL PRIMARY KEY,
    CartID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    PriceAtAddition DECIMAL(10,2),

    CONSTRAINT fk_cartitem_cart
        FOREIGN KEY (CartID)
        REFERENCES ShoppingCart(CartID),

    CONSTRAINT fk_cartitem_product
        FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);


CREATE TABLE Coupon (
    CouponID SERIAL PRIMARY KEY,
    CouponCode VARCHAR(30) UNIQUE,
    DiscountType VARCHAR(20),
    DiscountValue DECIMAL(10,2),
    MinimumOrderValue DECIMAL(10,2),
    StartDate DATE,
    ExpiryDate DATE,
    CouponStatus VARCHAR(20)
);


CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    CouponID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    OrderStatus VARCHAR(30),
    ShippingAddress TEXT,
    BillingAddress TEXT,
    TotalAmount DECIMAL(12,2),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),

    CONSTRAINT fk_orders_coupon
        FOREIGN KEY (CouponID)
        REFERENCES Coupon(CouponID)
);


CREATE TABLE OrderItem (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2),
    DiscountApplied DECIMAL(10,2),
    TotalPrice DECIMAL(10,2),

    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);


CREATE TABLE Payment (
    PaymentID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentMethod VARCHAR(30),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TransactionID VARCHAR(100),
    PaymentStatus VARCHAR(20),
    AmountPaid DECIMAL(12,2),

    CONSTRAINT fk_payment_order
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
);


CREATE TABLE Shipment (
    ShipmentID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    CourierPartner VARCHAR(100),
    TrackingNumber VARCHAR(100),
    ShipmentDate DATE,
    ExpectedDeliveryDate DATE,
    ActualDeliveryDate DATE,
    ShipmentStatus VARCHAR(30),

    CONSTRAINT fk_shipment_order
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
);


CREATE TABLE Review (
    ReviewID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Rating DECIMAL(2,1),
    ReviewText TEXT,
    ReviewDate DATE,

    CONSTRAINT fk_review_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),

    CONSTRAINT fk_review_product
        FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);


CREATE TABLE Wishlist (
    WishlistID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    DateAdded DATE,

    CONSTRAINT fk_wishlist_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),

    CONSTRAINT fk_wishlist_product
        FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);


CREATE TABLE ReturnRefund (
    ReturnID SERIAL PRIMARY KEY,
    OrderItemID INT NOT NULL,
    ReturnReason TEXT,
    ReturnRequestDate DATE,
    PickupDate DATE,
    RefundAmount DECIMAL(10,2),
    RefundStatus VARCHAR(20),

    CONSTRAINT fk_return_orderitem
        FOREIGN KEY (OrderItemID)
        REFERENCES OrderItem(OrderItemID)
);


SELECT * FROM Customer;

