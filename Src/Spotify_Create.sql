Use Spotify
Go

-- Drop
Drop Table PerformingArtist
Drop Table PlaylistSong
Drop Table Song
Drop Table Genre
Drop Table Album
Drop Table Artist
Drop Table Playlist
Drop Table RegisteredUser
Drop Table Search
Drop Table SearchDetails


-- RegisteredUser
create table RegisteredUser (
    username varchar(20) primary key,
	firstName varchar(20),
	lastName varchar(20),
	email varchar(30) not null,
	password varchar(20) not null,
	type varchar(20) not null
)

-- Playlist
create table Playlist (
	 id int primary key,
     title varchar(20) not null,
	 userName varchar(20) references RegisteredUser(username),
	 createDate date not null,
	 description varchar(100),
)

-- Artist
create table Artist (
	id int primary key,
    firstName varchar(20) not null,
	lastName varchar(20) not null,
	dateOfBirth date not null,
	Country smallint,
)

-- Album
create table Album (
    id smallint primary key,
	number tinyint not null,
	title varchar(20) not null,
	artistId int references Artist(id),
	releaseDate date not null,
	coverImage varchar(100)
)

-- Genre
create table Genre (
    name varchar(20) primary key,
	description varchar(100),
)

-- Song
create table Song (
    id int primary key,
	title varchar(20) not null,
	length smallint not null,
	releaseDate date not null,
	albumId smallint references Album(id),
	genreName varchar(20) references Genre(name),
	numberOfPlays int not null
)

-- PlaylistSong
create table PlaylistSong (
	playlistId int references Playlist(id),
	songId int references Song(id),
    primary key(playlistId,songId)
)

-- PerformingArtist
create table PerformingArtist (
    songId int references Song(id),
	artistId int references Artist(id),
	primary key(songId,artistId)
)

-- Search
create table Search (
	userName varchar(20) NOT NULL,
	searchTime varchar(30) NOT NULL,
	searchFirstName varchar(20) NOT NULL,
	searchLastName varchar(20) NOT NULL,
	searchCountry varchar(20) NOT NULL,
	CONSTRAINT PK_Search PRIMARY KEY (userName,searchTime),
	FOREIGN KEY (userName) REFERENCES RegisteredUser(username)
);

-- SearchDetails
create table SearchDetails (
	userName varchar(20) NOT NULL,
	searchTime varchar(30) NOT NULL,
	clickNum int IDENTITY(1,1) NOT NULL,
	artistID int NOT NULL,
	CONSTRAINT PK_SearchDetails PRIMARY KEY (userName,searchTime,clickNum),
	CONSTRAINT FK_SearchDetails1 FOREIGN KEY (userName,searchTime)
	REFERENCES Search(userName,searchTime),
	CONSTRAINT FK_SearchDetails2 FOREIGN KEY (artistID)
	REFERENCES Artist(id)
);
