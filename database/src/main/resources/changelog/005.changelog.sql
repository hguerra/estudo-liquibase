--liquibase formatted sql

--changeset marcopollivier:1
CREATE SEQUENCE IF NOT EXISTS hibernate_sequence;

CREATE TABLE IF NOT EXISTS product (
 id BIGINT NOT NULL CONSTRAINT product_pkey PRIMARY KEY ,
 description VARCHAR(255),
 name VARCHAR(255),
 parent_product_id BIGINT CONSTRAINT product_parent_fkey references product
);
--rollback ALTER TABLE product DROP CONSTRAINT product_parent_fkey;
--rollback DROP TABLE product;
--rollback DROP SEQUENCE hibernate_sequence;

--changeset outrousuario:2
CREATE TABLE IF NOT EXISTS image (
 id BIGINT NOT NULL CONSTRAINT image_pkey PRIMARY KEY,
 type VARCHAR(255),
 product_id BIGINT CONSTRAINT product_image_fkey REFERENCES product
);
--rollback ALTER TABLE image DROP CONSTRAINT product_image_fkey;
--rollback DROP TABLE image;
