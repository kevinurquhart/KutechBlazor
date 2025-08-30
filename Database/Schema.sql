USE [Kutech]
GO

-- =====================================================
-- Core Product/Service Tables
-- =====================================================

-- Product Categories (Course, Consultancy, Health Check, etc.)
CREATE TABLE dbo.ProductCategories (
    CategoryID int IDENTITY(1,1) NOT NULL,
    CategoryName nvarchar(100) NOT NULL,
    CategoryDescription nvarchar(500) NULL,
    DisplayOrder int NOT NULL DEFAULT 0,
    IsActive bit NOT NULL DEFAULT 1,
    CreatedDate datetime NOT NULL DEFAULT GETDATE(),
    ModifiedDate datetime NULL,
    CONSTRAINT PK_ProductCategories PRIMARY KEY CLUSTERED (CategoryID)
)
GO

-- Product Types (more granular than categories)
CREATE TABLE dbo.ProductTypes (
    ProductTypeID int IDENTITY(1,1) NOT NULL,
    ProductTypeName nvarchar(100) NOT NULL,
    CategoryID int NOT NULL,
    CONSTRAINT PK_ProductTypes PRIMARY KEY CLUSTERED (ProductTypeID),
    CONSTRAINT FK_ProductTypes_Categories FOREIGN KEY (CategoryID) 
        REFERENCES dbo.ProductCategories(CategoryID)
)
GO

-- Delivery Methods (Online, Remote, In-Person, Self-Paced, etc.)
CREATE TABLE dbo.DeliveryMethods (
    DeliveryMethodID int IDENTITY(1,1) NOT NULL,
    MethodName nvarchar(50) NOT NULL,
    MethodDescription nvarchar(200) NULL,
    IsActive bit NOT NULL DEFAULT 1,
    CONSTRAINT PK_DeliveryMethods PRIMARY KEY CLUSTERED (DeliveryMethodID)
)
GO

-- Skill Levels
CREATE TABLE dbo.SkillLevels (
    SkillLevelID int IDENTITY(1,1) NOT NULL,
    LevelName nvarchar(50) NOT NULL, -- Beginner, Intermediate, Advanced, Expert
    LevelOrder int NOT NULL,
    CONSTRAINT PK_SkillLevels PRIMARY KEY CLUSTERED (SkillLevelID)
)
GO

-- Main Products table (base information for all product types)
CREATE TABLE dbo.Products (
    ProductID int IDENTITY(1,1) NOT NULL,
    ProductCode nvarchar(50) NOT NULL, -- Unique SKU
    ProductName nvarchar(200) NOT NULL,
    ShortDescription nvarchar(500) NULL,
    FullDescription nvarchar(max) NULL,
    CategoryID int NOT NULL,
    ProductTypeID int NULL,
    ImageUrl nvarchar(500) NULL,
    ThumbnailUrl nvarchar(500) NULL,
    IsFeatured bit NOT NULL DEFAULT 0,
    IsActive bit NOT NULL DEFAULT 1,
    DisplayOrder int NOT NULL DEFAULT 0,
    MetaTitle nvarchar(200) NULL,
    MetaDescription nvarchar(500) NULL,
    MetaKeywords nvarchar(500) NULL,
    CreatedDate datetime NOT NULL DEFAULT GETDATE(),
    ModifiedDate datetime NULL,
    CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (ProductID),
    CONSTRAINT UK_Products_Code UNIQUE (ProductCode),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) 
        REFERENCES dbo.ProductCategories(CategoryID),
    CONSTRAINT FK_Products_Types FOREIGN KEY (ProductTypeID) 
        REFERENCES dbo.ProductTypes(ProductTypeID)
)
GO

-- Product Variants (different delivery methods/pricing for same product)
CREATE TABLE dbo.ProductVariants (
    VariantID int IDENTITY(1,1) NOT NULL,
    ProductID int NOT NULL,
    VariantName nvarchar(200) NOT NULL, -- e.g., "SQL Server Fundamentals - Online"
    VariantSKU nvarchar(50) NOT NULL,
    DeliveryMethodID int NULL,
    Price decimal(10,2) NOT NULL,
    SalePrice decimal(10,2) NULL,
    IsOnSale bit NOT NULL DEFAULT 0,
    StockQuantity int NULL, -- NULL for unlimited (services)
    MaxAttendees int NULL, -- For courses with limited seats
    IsActive bit NOT NULL DEFAULT 1,
    CONSTRAINT PK_ProductVariants PRIMARY KEY CLUSTERED (VariantID),
    CONSTRAINT UK_ProductVariants_SKU UNIQUE (VariantSKU),
    CONSTRAINT FK_ProductVariants_Products FOREIGN KEY (ProductID) 
        REFERENCES dbo.Products(ProductID) ON DELETE CASCADE,
    CONSTRAINT FK_ProductVariants_DeliveryMethods FOREIGN KEY (DeliveryMethodID) 
        REFERENCES dbo.DeliveryMethods(DeliveryMethodID)
)
GO

-- Course-specific information
CREATE TABLE dbo.CourseDetails (
    CourseDetailID int IDENTITY(1,1) NOT NULL,
    ProductID int NOT NULL,
    DurationValue decimal(5,2) NOT NULL, -- Numeric duration
    DurationUnit nvarchar(20) NOT NULL, -- 'Days', 'Hours', 'Minutes'
    SkillLevelID int NULL,
    Prerequisites nvarchar(max) NULL,
    LearningObjectives nvarchar(max) NULL,
    CourseOutline nvarchar(max) NULL,
    CertificationOffered bit NOT NULL DEFAULT 0,
    CPDPoints int NULL,
    CONSTRAINT PK_CourseDetails PRIMARY KEY CLUSTERED (CourseDetailID),
    CONSTRAINT FK_CourseDetails_Products FOREIGN KEY (ProductID) 
        REFERENCES dbo.Products(ProductID) ON DELETE CASCADE,
    CONSTRAINT FK_CourseDetails_SkillLevels FOREIGN KEY (SkillLevelID) 
        REFERENCES dbo.SkillLevels(SkillLevelID)
)
GO

-- Service-specific information (consultancy, health checks, etc.)
CREATE TABLE dbo.ServiceDetails (
    ServiceDetailID int IDENTITY(1,1) NOT NULL,
    ProductID int NOT NULL,
    ServiceType nvarchar(50) NOT NULL, -- 'Consultancy', 'HealthCheck', 'Support', 'Webinar'
    MinimumHours decimal(5,2) NULL,
    MaximumHours decimal(5,2) NULL,
    RateType nvarchar(20) NULL, -- 'Hourly', 'Daily', 'Fixed', 'Project'
    TypicalDuration nvarchar(100) NULL, -- Free text like "2-3 days typical engagement"
    Deliverables nvarchar(max) NULL,
    CONSTRAINT PK_ServiceDetails PRIMARY KEY CLUSTERED (ServiceDetailID),
    CONSTRAINT FK_ServiceDetails_Products FOREIGN KEY (ProductID) 
        REFERENCES dbo.Products(ProductID) ON DELETE CASCADE
)
GO

-- Course Schedule (for scheduled courses)
CREATE TABLE dbo.CourseSchedule (
    ScheduleID int IDENTITY(1,1) NOT NULL,
    VariantID int NOT NULL,
    StartDate datetime NOT NULL,
    EndDate datetime NOT NULL,
    TimeZone nvarchar(50) NULL DEFAULT 'GMT',
    Location nvarchar(200) NULL, -- For in-person courses
    InstructorName nvarchar(100) NULL,
    CurrentEnrollment int NOT NULL DEFAULT 0,
    MaxEnrollment int NOT NULL,
    RegistrationDeadline datetime NULL,
    Status nvarchar(20) NOT NULL DEFAULT 'Scheduled', -- Scheduled, Confirmed, Cancelled, Completed
    Notes nvarchar(max) NULL,
    CONSTRAINT PK_CourseSchedule PRIMARY KEY CLUSTERED (ScheduleID),
    CONSTRAINT FK_CourseSchedule_Variants FOREIGN KEY (VariantID) 
        REFERENCES dbo.ProductVariants(VariantID)
)
GO

-- Product Tags (for search and categorization)
CREATE TABLE dbo.Tags (
    TagID int IDENTITY(1,1) NOT NULL,
    TagName nvarchar(50) NOT NULL,
    CONSTRAINT PK_Tags PRIMARY KEY CLUSTERED (TagID),
    CONSTRAINT UK_Tags_Name UNIQUE (TagName)
)
GO

CREATE TABLE dbo.ProductTags (
    ProductID int NOT NULL,
    TagID int NOT NULL,
    CONSTRAINT PK_ProductTags PRIMARY KEY CLUSTERED (ProductID, TagID),
    CONSTRAINT FK_ProductTags_Products FOREIGN KEY (ProductID) 
        REFERENCES dbo.Products(ProductID) ON DELETE CASCADE,
    CONSTRAINT FK_ProductTags_Tags FOREIGN KEY (TagID) 
        REFERENCES dbo.Tags(TagID) ON DELETE CASCADE
)
GO

-- =====================================================
-- Shopping Cart Tables
-- =====================================================

CREATE TABLE dbo.CartItems (
    ItemID int IDENTITY(1,1) NOT NULL,
    CartID nvarchar(128) NOT NULL,
    VariantID int NOT NULL, -- Links to ProductVariants, not Products
    Quantity int NOT NULL DEFAULT 1,
    ScheduleID int NULL, -- For scheduled courses
    CustomizationNotes nvarchar(max) NULL, -- For special requirements
    DateAdded datetime NOT NULL DEFAULT GETDATE(),
    DateModified datetime NULL,
    CONSTRAINT PK_CartItems PRIMARY KEY CLUSTERED (ItemID),
    CONSTRAINT FK_CartItems_Variants FOREIGN KEY (VariantID) 
        REFERENCES dbo.ProductVariants(VariantID),
    CONSTRAINT FK_CartItems_Schedule FOREIGN KEY (ScheduleID) 
        REFERENCES dbo.CourseSchedule(ScheduleID)
)
GO

-- Create indexes for performance
CREATE NONCLUSTERED INDEX IX_CartItems_CartID 
    ON dbo.CartItems(CartID) 
    INCLUDE (VariantID, Quantity, ScheduleID)
GO

CREATE NONCLUSTERED INDEX IX_Products_Category 
    ON dbo.Products(CategoryID, IsActive) 
    INCLUDE (ProductName, ShortDescription)
GO

CREATE NONCLUSTERED INDEX IX_ProductVariants_Product 
    ON dbo.ProductVariants(ProductID, IsActive) 
    INCLUDE (Price, SalePrice, DeliveryMethodID)
GO

-- =====================================================
-- Insert Reference Data
-- =====================================================

-- Insert Product Categories
INSERT INTO dbo.ProductCategories (CategoryName, CategoryDescription, DisplayOrder) VALUES
('Training Courses', 'Professional IT training and certification courses', 1),
('Consultancy', 'Expert consultancy services', 2),
('Health Checks', 'SQL Server and system health assessments', 3),
('Support Services', 'Ongoing support and maintenance', 4),
('Webinars', 'Online seminars and talks', 5),
('Resources', 'Training materials and resources', 6);

-- Insert Product Types
INSERT INTO dbo.ProductTypes (ProductTypeName, CategoryID) 
SELECT 'SQL Server Training', CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Training Courses'
UNION ALL
SELECT 'Azure Training', CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Training Courses'
UNION ALL
SELECT 'Power BI Training', CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Training Courses'
UNION ALL
SELECT 'Database Consultancy', CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Consultancy'
UNION ALL
SELECT 'Performance Tuning', CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Consultancy'
UNION ALL
SELECT 'SQL Server Health Check', CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Health Checks'
UNION ALL
SELECT 'Managed Services', CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Support Services';

-- Insert Delivery Methods
INSERT INTO dbo.DeliveryMethods (MethodName, MethodDescription) VALUES
('Online Live', 'Live instructor-led online training'),
('Remote', 'Remote delivery to your location'),
('In-Person', 'Face-to-face classroom training'),
('Self-Paced', 'Learn at your own pace'),
('On-Site', 'Delivered at your premises'),
('Hybrid', 'Combination of online and in-person');

-- Insert Skill Levels
INSERT INTO dbo.SkillLevels (LevelName, LevelOrder) VALUES
('Beginner', 1),
('Intermediate', 2),
('Advanced', 3),
('Expert', 4);

-- =====================================================
-- Stored Procedures
-- =====================================================

-- Get Products by Category
IF OBJECT_ID('dbo.GetProductsByCategory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetProductsByCategory
GO

CREATE PROCEDURE dbo.GetProductsByCategory
    @CategoryID int = NULL,
    @IncludeInactive bit = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductID,
        p.ProductCode,
        p.ProductName,
        p.ShortDescription,
        p.FullDescription,
        p.CategoryID,
        pc.CategoryName,
        p.ProductTypeID,
        pt.ProductTypeName,
        p.ImageUrl,
        p.ThumbnailUrl,
        p.IsFeatured,
        p.IsActive,
        p.DisplayOrder
    FROM dbo.Products p
    INNER JOIN dbo.ProductCategories pc ON p.CategoryID = pc.CategoryID
    LEFT JOIN dbo.ProductTypes pt ON p.ProductTypeID = pt.ProductTypeID
    WHERE (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
        AND (@IncludeInactive = 1 OR p.IsActive = 1)
    ORDER BY p.DisplayOrder, p.ProductName
END
GO

-- Get Product Variants with Pricing
IF OBJECT_ID('dbo.GetProductVariants', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetProductVariants
GO

CREATE PROCEDURE dbo.GetProductVariants
    @ProductID int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pv.VariantID,
        pv.ProductID,
        pv.VariantName,
        pv.VariantSKU,
        pv.DeliveryMethodID,
        dm.MethodName as DeliveryMethod,
        pv.Price,
        pv.SalePrice,
        pv.IsOnSale,
        COALESCE(pv.SalePrice, pv.Price) as CurrentPrice,
        pv.StockQuantity,
        pv.MaxAttendees,
        pv.IsActive
    FROM dbo.ProductVariants pv
    LEFT JOIN dbo.DeliveryMethods dm ON pv.DeliveryMethodID = dm.DeliveryMethodID
    WHERE pv.ProductID = @ProductID
        AND pv.IsActive = 1
    ORDER BY pv.Price
END
GO

-- Get Featured Products
IF OBJECT_ID('dbo.GetFeaturedProducts', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetFeaturedProducts
GO

CREATE PROCEDURE dbo.GetFeaturedProducts
    @MaxCount int = 6
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@MaxCount)
        p.ProductID,
        p.ProductCode,
        p.ProductName,
        p.ShortDescription,
        p.CategoryID,
        pc.CategoryName,
        p.ImageUrl,
        p.ThumbnailUrl,
        MIN(COALESCE(pv.SalePrice, pv.Price)) as StartingPrice,
        COUNT(pv.VariantID) as VariantCount
    FROM dbo.Products p
    INNER JOIN dbo.ProductCategories pc ON p.CategoryID = pc.CategoryID
    INNER JOIN dbo.ProductVariants pv ON p.ProductID = pv.ProductID
    WHERE p.IsFeatured = 1 
        AND p.IsActive = 1
        AND pv.IsActive = 1
    GROUP BY p.ProductID, p.ProductCode, p.ProductName, p.ShortDescription, 
             p.CategoryID, pc.CategoryName, p.ImageUrl, p.ThumbnailUrl, p.DisplayOrder
    ORDER BY p.DisplayOrder, p.ProductName
END
GO

-- Add to Cart (Updated for variants)
IF OBJECT_ID('dbo.AddToCart', 'P') IS NOT NULL
    DROP PROCEDURE dbo.AddToCart
GO

CREATE PROCEDURE dbo.AddToCart
    @CartID nvarchar(128),
    @VariantID int,
    @Quantity int = 1,
    @ScheduleID int = NULL,
    @CustomizationNotes nvarchar(max) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if item already exists in cart
    IF EXISTS (SELECT 1 FROM dbo.CartItems 
               WHERE CartID = @CartID 
                 AND VariantID = @VariantID 
                 AND (ScheduleID = @ScheduleID OR (ScheduleID IS NULL AND @ScheduleID IS NULL)))
    BEGIN
        -- Update quantity
        UPDATE dbo.CartItems
        SET Quantity = Quantity + @Quantity,
            DateModified = GETDATE()
        WHERE CartID = @CartID 
          AND VariantID = @VariantID
          AND (ScheduleID = @ScheduleID OR (ScheduleID IS NULL AND @ScheduleID IS NULL))
    END
    ELSE
    BEGIN
        -- Insert new item
        INSERT INTO dbo.CartItems (CartID, VariantID, Quantity, ScheduleID, CustomizationNotes, DateAdded)
        VALUES (@CartID, @VariantID, @Quantity, @ScheduleID, @CustomizationNotes, GETDATE())
    END
    
    -- Return the updated item count
    SELECT COUNT(*) as ItemCount, SUM(Quantity) as TotalQuantity
    FROM dbo.CartItems
    WHERE CartID = @CartID
END
GO

-- Get Cart Items with Product Details
IF OBJECT_ID('dbo.GetCartItems', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetCartItems
GO

CREATE PROCEDURE dbo.GetCartItems
    @CartID nvarchar(128)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ci.ItemID,
        ci.CartID,
        ci.VariantID,
        ci.Quantity,
        ci.ScheduleID,
        ci.CustomizationNotes,
        ci.DateAdded,
        pv.VariantName,
        pv.VariantSKU,
        COALESCE(pv.SalePrice, pv.Price) as UnitPrice,
        (ci.Quantity * COALESCE(pv.SalePrice, pv.Price)) as LineTotal,
        p.ProductID,
        p.ProductName,
        p.ShortDescription,
        p.ThumbnailUrl,
        pc.CategoryName,
        dm.MethodName as DeliveryMethod,
        cs.StartDate,
        cs.EndDate,
        cs.Location
    FROM dbo.CartItems ci
    INNER JOIN dbo.ProductVariants pv ON ci.VariantID = pv.VariantID
    INNER JOIN dbo.Products p ON pv.ProductID = p.ProductID
    INNER JOIN dbo.ProductCategories pc ON p.CategoryID = pc.CategoryID
    LEFT JOIN dbo.DeliveryMethods dm ON pv.DeliveryMethodID = dm.DeliveryMethodID
    LEFT JOIN dbo.CourseSchedule cs ON ci.ScheduleID = cs.ScheduleID
    WHERE ci.CartID = @CartID
    ORDER BY ci.DateAdded DESC
END
GO

-- Get Cart Total
IF OBJECT_ID('dbo.GetCartTotal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetCartTotal
GO

CREATE PROCEDURE dbo.GetCartTotal
    @CartID nvarchar(128)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(DISTINCT ci.ItemID) as ItemCount,
        SUM(ci.Quantity) as TotalQuantity,
        ISNULL(SUM(ci.Quantity * COALESCE(pv.SalePrice, pv.Price)), 0) as SubTotal,
        ISNULL(SUM(CASE WHEN pv.IsOnSale = 1 
                   THEN ci.Quantity * (pv.Price - pv.SalePrice) 
                   ELSE 0 END), 0) as TotalDiscount,
        ISNULL(SUM(ci.Quantity * COALESCE(pv.SalePrice, pv.Price)), 0) as GrandTotal
    FROM dbo.CartItems ci
    INNER JOIN dbo.ProductVariants pv ON ci.VariantID = pv.VariantID
    WHERE ci.CartID = @CartID
END
GO

-- Update Cart Item Quantity
IF OBJECT_ID('dbo.UpdateCartItemQuantity', 'P') IS NOT NULL
    DROP PROCEDURE dbo.UpdateCartItemQuantity
GO

CREATE PROCEDURE dbo.UpdateCartItemQuantity
    @CartID nvarchar(128),
    @ItemID int,
    @Quantity int
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Quantity <= 0
    BEGIN
        -- Remove item if quantity is 0 or less
        DELETE FROM dbo.CartItems
        WHERE CartID = @CartID AND ItemID = @ItemID
    END
    ELSE
    BEGIN
        -- Update quantity
        UPDATE dbo.CartItems
        SET Quantity = @Quantity,
            DateModified = GETDATE()
        WHERE CartID = @CartID AND ItemID = @ItemID
    END
    
    -- Return the updated cart total
    EXEC GetCartTotal @CartID
END
GO

-- Remove from Cart
IF OBJECT_ID('dbo.RemoveFromCart', 'P') IS NOT NULL
    DROP PROCEDURE dbo.RemoveFromCart
GO

CREATE PROCEDURE dbo.RemoveFromCart
    @CartID nvarchar(128),
    @ItemID int
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM dbo.CartItems
    WHERE CartID = @CartID AND ItemID = @ItemID
    
    -- Return the updated cart total
    EXEC GetCartTotal @CartID
END
GO

-- Clear Cart
IF OBJECT_ID('dbo.ClearCart', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ClearCart
GO

CREATE PROCEDURE dbo.ClearCart
    @CartID nvarchar(128)
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM dbo.CartItems
    WHERE CartID = @CartID
    
    SELECT 0 as ItemCount, 0 as TotalQuantity, 0 as GrandTotal
END
GO

-- Migrate Cart (when user logs in)
IF OBJECT_ID('dbo.MigrateCart', 'P') IS NOT NULL
    DROP PROCEDURE dbo.MigrateCart
GO

CREATE PROCEDURE dbo.MigrateCart
    @AnonymousCartID nvarchar(128),
    @UserCartID nvarchar(128)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- For items that exist in both carts, keep the user cart version
    -- and add the anonymous quantities
    UPDATE uc
    SET uc.Quantity = uc.Quantity + ac.Quantity,
        uc.DateModified = GETDATE()
    FROM dbo.CartItems uc
    INNER JOIN dbo.CartItems ac 
        ON uc.VariantID = ac.VariantID 
        AND ac.CartID = @AnonymousCartID
        AND (uc.ScheduleID = ac.ScheduleID OR (uc.ScheduleID IS NULL AND ac.ScheduleID IS NULL))
    WHERE uc.CartID = @UserCartID
    
    -- Insert items from anonymous cart that don't exist in user cart
    INSERT INTO dbo.CartItems (CartID, VariantID, Quantity, ScheduleID, CustomizationNotes, DateAdded)
    SELECT @UserCartID, VariantID, Quantity, ScheduleID, CustomizationNotes, GETDATE()
    FROM dbo.CartItems
    WHERE CartID = @AnonymousCartID
        AND NOT EXISTS (
            SELECT 1 
            FROM dbo.CartItems uc
            WHERE uc.CartID = @UserCartID 
              AND uc.VariantID = CartItems.VariantID
              AND (uc.ScheduleID = CartItems.ScheduleID OR (uc.ScheduleID IS NULL AND CartItems.ScheduleID IS NULL))
        )
    
    -- Delete the anonymous cart
    DELETE FROM dbo.CartItems WHERE CartID = @AnonymousCartID
    
    -- Return the migrated cart total
    EXEC GetCartTotal @UserCartID
END
GO

-- Search Products
IF OBJECT_ID('dbo.SearchProducts', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SearchProducts
GO

CREATE PROCEDURE dbo.SearchProducts
    @SearchTerm nvarchar(100),
    @CategoryID int = NULL,
    @MinPrice decimal(10,2) = NULL,
    @MaxPrice decimal(10,2) = NULL,
    @DeliveryMethodID int = NULL,
    @SkillLevelID int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT
        p.ProductID,
        p.ProductCode,
        p.ProductName,
        p.ShortDescription,
        p.CategoryID,
        pc.CategoryName,
        p.ImageUrl,
        p.ThumbnailUrl,
        MIN(COALESCE(pv.SalePrice, pv.Price)) as StartingPrice,
        MAX(COALESCE(pv.SalePrice, pv.Price)) as MaxPrice
    FROM dbo.Products p
    INNER JOIN dbo.ProductCategories pc ON p.CategoryID = pc.CategoryID
    INNER JOIN dbo.ProductVariants pv ON p.ProductID = pv.ProductID
    LEFT JOIN dbo.CourseDetails cd ON p.ProductID = cd.ProductID
    LEFT JOIN dbo.ProductTags pt ON p.ProductID = pt.ProductID
    LEFT JOIN dbo.Tags t ON pt.TagID = t.TagID
    WHERE p.IsActive = 1
        AND pv.IsActive = 1
        AND (@SearchTerm IS NULL OR 
             p.ProductName LIKE '%' + @SearchTerm + '%' OR
             p.ShortDescription LIKE '%' + @SearchTerm + '%' OR
             p.FullDescription LIKE '%' + @SearchTerm + '%' OR
             t.TagName LIKE '%' + @SearchTerm + '%')
        AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
        AND (@DeliveryMethodID IS NULL OR pv.DeliveryMethodID = @DeliveryMethodID)
        AND (@SkillLevelID IS NULL OR cd.SkillLevelID = @SkillLevelID)
    GROUP BY p.ProductID, p.ProductCode, p.ProductName, p.ShortDescription,
             p.CategoryID, pc.CategoryName, p.ImageUrl, p.ThumbnailUrl
    HAVING (@MinPrice IS NULL OR MIN(COALESCE(pv.SalePrice, pv.Price)) >= @MinPrice)
        AND (@MaxPrice IS NULL OR MIN(COALESCE(pv.SalePrice, pv.Price)) <= @MaxPrice)
    ORDER BY p.ProductName
END
GO

-- =====================================================
-- Sample Data (Remove this section in production)
-- =====================================================

-- Insert sample product: SQL Server Fundamentals Course
DECLARE @ProductID int, @VariantID int

INSERT INTO dbo.Products (ProductCode, ProductName, ShortDescription, FullDescription, CategoryID, IsFeatured, IsActive)
VALUES ('SQL-FUND-001', 
        'SQL Server Fundamentals', 
        'Complete introduction to Microsoft SQL Server for beginners',
        'This comprehensive course covers all the essential concepts of SQL Server...',
        (SELECT CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Training Courses'),
        1, 1)

SET @ProductID = SCOPE_IDENTITY()

-- Add course details
INSERT INTO dbo.CourseDetails (ProductID, DurationValue, DurationUnit, SkillLevelID, Prerequisites)
VALUES (@ProductID, 3, 'Days', 
        (SELECT SkillLevelID FROM dbo.SkillLevels WHERE LevelName = 'Beginner'),
        'Basic computer skills and understanding of databases')

-- Add variants for different delivery methods
INSERT INTO dbo.ProductVariants (ProductID, VariantName, VariantSKU, DeliveryMethodID, Price, IsActive)
VALUES 
(@ProductID, 'SQL Server Fundamentals - Online Live', 'SQL-FUND-001-OL', 
 (SELECT DeliveryMethodID FROM dbo.DeliveryMethods WHERE MethodName = 'Online Live'), 1495.00, 1),
(@ProductID, 'SQL Server Fundamentals - In-Person', 'SQL-FUND-001-IP', 
 (SELECT DeliveryMethodID FROM dbo.DeliveryMethods WHERE MethodName = 'In-Person'), 1795.00, 1),
(@ProductID, 'SQL Server Fundamentals - Self-Paced', 'SQL-FUND-001-SP', 
 (SELECT DeliveryMethodID FROM dbo.DeliveryMethods WHERE MethodName = 'Self-Paced'), 795.00, 1)

-- Insert sample service: SQL Server Health Check
INSERT INTO dbo.Products (ProductCode, ProductName, ShortDescription, CategoryID, IsFeatured, IsActive)
VALUES ('SVC-HLTH-001', 
        'SQL Server Health Check', 
        'Comprehensive assessment of your SQL Server environment',
        (SELECT CategoryID FROM dbo.ProductCategories WHERE CategoryName = 'Health Checks'),
        1, 1)

SET @ProductID = SCOPE_IDENTITY()

-- Add service details
INSERT INTO dbo.ServiceDetails (ProductID, ServiceType, MinimumHours, RateType, TypicalDuration)
VALUES (@ProductID, 'HealthCheck', 8, 'Fixed', '1-2 days')

-- Add single variant for health check
INSERT INTO dbo.ProductVariants (ProductID, VariantName, VariantSKU, Price, IsActive)
VALUES (@ProductID, 'SQL Server Health Check - Standard', 'SVC-HLTH-001-STD', 2495.00, 1)

-- =====================================================
-- Grant Permissions
-- =====================================================

-- Grant permissions to the application user
GRANT EXECUTE ON SCHEMA::dbo TO [KutechBlazorUser]
GO

PRINT 'Kutech database schema created successfully!'
PRINT 'Remember to:'
PRINT '1. Create the KutechBlazorUser login if it doesn''t exist'
PRINT '2. Map the user to this database'
PRINT '3. Update connection strings in your application'