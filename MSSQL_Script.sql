USE [eticaretdb]
GO
/****** Object:  Table [dbo].[tblproduct]    Script Date: 25.11.2024 15:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblproduct](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[urunAdi] [nchar](150) NULL,
	[fiyat] [decimal](9, 2) NULL,
	[miktar] [decimal](9, 2) NULL,
	[imageURL] [nchar](200) NULL,
 CONSTRAINT [PK_tblproduct] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  StoredProcedure [dbo].[addProductSP]    Script Date: 25.11.2024 15:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[addProductSP]
    @p_urunAdi NVARCHAR(150),
    @p_fiyat DECIMAL(9, 2),
    @p_miktar DECIMAL(9, 2),
    @p_imageURL NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Ürün ekle
        INSERT INTO tblproduct (urunAdi, fiyat, miktar, imageURL)
        VALUES (@p_urunAdi, @p_fiyat, @p_miktar, @p_imageURL);

        -- Başarılı ekleme işlemi sonrası JSON yanıtı döndür
        SELECT '{"isAdded": true, "message": "Kayıt Eklenmiştir"}' AS result;
    END TRY
    BEGIN CATCH
        -- Hata durumunda JSON yanıtı döndür
        SELECT '{"isAdded": false, "message": "Kayıt Eklenirken Hata Oluştu"}' AS result;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[deleteProductByIdSP]    Script Date: 25.11.2024 15:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteProductByIdSP]
    @p_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Ürünü sil
        DELETE FROM tblproduct WHERE id = @p_id;

        -- İşlem başarılıysa JSON yanıtı döndür
        IF @@ROWCOUNT > 0 
            SELECT '{"isDeleted": true, "message": "Kayıt Silinmiştir"}' AS result;
        ELSE
            SELECT '{"isDeleted": false, "message": "Kayıt Silinirken Hata Oluştu"}' AS result;
    END TRY
    BEGIN CATCH
        -- Hata durumunda JSON yanıtı döndür
        SELECT '{"isDeleted": false, "message": "Kayıt Silinirken Hata Oluştu"}' AS result;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[getAllProductsSP]    Script Date: 25.11.2024 15:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getAllProductsSP]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @json NVARCHAR(MAX) = '{ "product": [';

    -- Ürünleri JSON formatında toplamak için döngü
    DECLARE @id INT, @urunAdi NVARCHAR(150), @fiyat DECIMAL(9, 2), @miktar DECIMAL(9, 2), @imageURL NVARCHAR(200);
    
    DECLARE productCursor CURSOR FOR 
    SELECT id, urunAdi, fiyat, miktar, imageURL FROM tblproduct;

    OPEN productCursor;
    FETCH NEXT FROM productCursor INTO @id, @urunAdi, @fiyat, @miktar, @imageURL;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @json = @json + '{"productID": ' + CAST(@id AS NVARCHAR(10)) + 
                     ', "productName": "' + @urunAdi + 
                     '", "productPrice": ' + CAST(@fiyat AS NVARCHAR(10)) +
                     ', "productStock": ' + CAST(@miktar AS NVARCHAR(10)) +
                     ', "productPictureUrl": "' + @imageURL + '"},';
                     
        FETCH NEXT FROM productCursor INTO @id, @urunAdi, @fiyat, @miktar, @imageURL;
    END

    CLOSE productCursor;
    DEALLOCATE productCursor;

    -- Sondaki virgülü kaldırarak JSON dizisini kapatma
    SET @json = LEFT(@json, LEN(@json) - 1) + ']}';

    SELECT @json AS result;
END;

GO
/****** Object:  StoredProcedure [dbo].[getProductByIdSP]    Script Date: 25.11.2024 15:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getProductByIdSP]
    @p_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @json NVARCHAR(MAX);

    SELECT @json = 
        '{ "productID": ' + CAST(id AS NVARCHAR(10)) +
        ', "productName": "' + urunAdi +
        '", "productPrice": ' + CAST(fiyat AS NVARCHAR(10)) +
        ', "productStock": ' + CAST(miktar AS NVARCHAR(10)) +
        ', "productPictureUrl": "' + imageURL + '" }'
    FROM tblproduct
    WHERE id = @p_id;

    IF @json IS NULL
        SET @json = '{ "error": "Product not found" }';

    SELECT @json AS result;
END;

GO
