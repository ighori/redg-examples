
-- This is a simple schema with products, and customers that can buy these products and get them shipped to their address
-- It is, just like the other schemas here, an example schema that should not be used in production because of big design flaws
-- For example, if you change a product price, all earlier orders will contain the changed prices. And you can only order one of each item per order.

CREATE TABLE PRODUCT(
  GTIN_CODE VARCHAR2(13 CHAR) NOT NULL PRIMARY KEY, -- The GTIN/EAN 13-digit number of the product, saved as string for better search possibilities
  PRODUCT_NAME VARCHAR2(100 CHAR) NOT NULL,
  SHORT_DESCRIPTION VARCHAR2(1000 CHAR),
  PRICE DECIMAL(8,2) NOT NULL,
  QUANTITY_IN_STOCK INTEGER NOT NULL
);

CREATE TABLE ADDRESS(
  ID INTEGER NOT NULL PRIMARY KEY,
  STREET VARCHAR2(100 CHAR) NOT NULL ,
  HOUSE_NUMBER VARCHAR2(10 CHAR) NOT NULL ,
  ADDRESS_EXTRA VARCHAR2(100 CHAR),
  ZIPCODE VARCHAR2(20 CHAR) NOT NULL ,
  CITY VARCHAR2(100 CHAR) NOT NULL ,
  COUNTRY VARCHAR2(100 CHAR) NOT NULL
);

CREATE TABLE CUSTOMER(
  ID INTEGER NOT NULL PRIMARY KEY,
  FIRST_NAME VARCHAR2(100 CHAR) NOT NULL,
  LAST_NAME VARCHAR2(100 CHAR) NOT NULL,
);

CREATE TABLE CUSTOMER_ADDRESS(
  CUSTOMER_ID INTEGER NOT NULL,
  ADDRESS_ID INTEGER NOT NULL,

  PRIMARY KEY (CUSTOMER_ID, ADDRESS_ID),
  CONSTRAINT FK_CA_CUSTOMER FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(ID),
  CONSTRAINT FK_CA_ADDRESS FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESS(ID)
);

CREATE TABLE "ORDER"(
  CUSTOMER_ID INTEGER NOT NULL,
  ORDER_NUMBER INTEGER NOT NULL,

  SHIPPING_FEE DECIMAL(8,2) NOT NULL,

  PRIMARY KEY (CUSTOMER_ID, ORDER_NUMBER),
  CONSTRAINT FK_ORDER_CUSTOMER FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(ID)
);

CREATE TABLE PRODUCT_ORDER(
  GTIN_CODE VARCHAR2(13 CHAR) NOT NULL,
  CUSTOMER_ID INTEGER NOT NULL,
  ORDER_NUMBER INTEGER NOT NULL,

  PRIMARY KEY (GTIN_CODE, CUSTOMER_ID, ORDER_NUMBER),
  CONSTRAINT FK_PO_PRODUCT FOREIGN KEY (GTIN_CODE) REFERENCES PRODUCT(GTIN_CODE),
  CONSTRAINT FK_PO_ORDER FOREIGN KEY (CUSTOMER_ID, ORDER_NUMBER) REFERENCES "ORDER"(CUSTOMER_ID, ORDER_NUMBER)

);