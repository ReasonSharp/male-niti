/**************************************************************************************************************************************
 DESCRIPTION
***************************************************************************************************************************************
 This is the initial version of the database.
 Author & Designer      : Nikola Novak
 Contact                : nikola@maleniti.com
 Created                : 2024-11-04
 Last modification      : 2024-11-04
 Mod. description       : Initial version
 Previous modifications :
***************************************************************************************************************************************
 DEFINITIONS
***************************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------
 Databases
---------------------------------------------------------------------------------------------------------------------------------------
 blog                                                                                                                             + NEW
---------------------------------------------------------------------------------------------------------------------------------------
 Types
---------------------------------------------------------------------------------------------------------------------------------------
 mediatype                                                                                                                        + NEW
---------------------------------------------------------------------------------------------------------------------------------------
 Tables
---------------------------------------------------------------------------------------------------------------------------------------
 author                                                                                                                           + NEW
 blog                                                                                                                             + NEW
 blogauthor                                                                                                                       + NEW
 category                                                                                                                         + NEW
 media                                                                                                                            + NEW
 post                                                                                                                             + NEW
 postauthor                                                                                                                       + NEW
 postcategory                                                                                                                     + NEW

***************************************************************************************************************************************
 IMPLEMENTATIONS
***************************************************************************************************************************************/
/**************************************************************************************************************************************
 Databases
***************************************************************************************************************************************/
CREATE DATABASE blog;

/**************************************************************************************************************************************
 Types
***************************************************************************************************************************************/
CREATE TYPE mediatype AS ENUM ('image', 'video', 'audio');

/**************************************************************************************************************************************
 Tables
***************************************************************************************************************************************/
CREATE TABLE author (
 authorID SERIAL PRIMARY KEY,
 authorName TEXT NOT NULL,
 authorBio TEXT,
 authorPass VARCHAR(255) NOT NULL,
 authorSalt VARCHAR(255) NOT NULL
);

CREATE TABLE blog (
 blogID SERIAL PRIMARY KEY,
 blogTitle TEXT NOT NULL,
 blogDescription TEXT
);

CREATE TABLE category (
 categoryID SERIAL PRIMARY KEY,
 blogID INT NOT NULL REFERENCES blog (blogID),
 categoryName TEXT NOT NULL,
 categoryDescription TEXT,
 categoryImage TEXT NOT NULL
);

CREATE TABLE media (
 mediaID SERIAL PRIMARY KEY,
 mediaDesc TEXT NOT NULL,
 mediaType mediatype NOT NULL,
 mediaLink TEXT NOT NULL
);

CREATE TABLE post (
 postID SERIAL PRIMARY KEY,
 postPublishedDate TIMESTAMP(0) DEFAULT CURRENT_TIMESTAMP,
 postTitle TEXT NOT NULL,
 postContent TEXT NOT NULL
);

CREATE TABLE blogauthor (
 blogID INT NOT NULL REFERENCES blog (blogID),
 authorID INT NOT NULL REFERENCES author (authorID),
 blogauthorAlias TEXT,
 PRIMARY KEY (blogID, authorID)
);

CREATE TABLE postauthor (
 postID INT NOT NULL REFERENCES post (postID),
 authorID INT NOT NULL REFERENCES author (authorID),
 PRIMARY KEY (postID, authorID)
);

CREATE TABLE postcategory (
 postID INT NOT NULL REFERENCES post (postID),
 categoryID INT NOT NULL REFERENCES category (categoryID),
 PRIMARY KEY (postID, categoryID)
);