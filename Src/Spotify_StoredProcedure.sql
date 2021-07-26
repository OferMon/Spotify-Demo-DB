-----------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_SearchArtist @UserName varchar(20), @SearchTime varchar(30), @FirstName varchar(20), @LastName varchar(20), @Country varchar(20)
AS
	IF NOT EXISTS
	(select *
	from RegisteredUser
	where username = @UserName) BEGIN
		PRINT 'Error: no such username'
		SELECT TOP 0  dbo.Artist.id AS ArtistID, dbo.Artist.firstName, dbo.Artist.lastName, dbo.AlbumsPerArtistView.numOfAlbums, dbo.PerformancesPerArtistView.numOfPerformances, dbo.Country.name AS countryName, dbo.Artist.dateOfBirth
		FROM          dbo.Artist INNER JOIN
		              dbo.Country ON dbo.Artist.Country = dbo.Country.id INNER JOIN
				      dbo.AlbumsPerArtistView ON dbo.Artist.id = dbo.AlbumsPerArtistView.id INNER JOIN
					  dbo.PerformancesPerArtistView ON dbo.Artist.id = dbo.PerformancesPerArtistView.id
		GROUP BY dbo.Artist.id, dbo.Artist.firstName, dbo.Artist.lastName, dbo.Artist.dateOfBirth, dbo.Country.name, dbo.AlbumsPerArtistView.numOfAlbums, dbo.PerformancesPerArtistView.numOfPerformances
	END
	ELSE BEGIN
		insert into Search(userName, searchTime, searchFirstName, searchLastName, searchCountry)
		values (@UserName, @SearchTime, @FirstName, @LastName, @Country)
		SELECT        dbo.Artist.id AS ArtistID, dbo.Artist.firstName, dbo.Artist.lastName, dbo.AlbumsPerArtistView.numOfAlbums, dbo.PerformancesPerArtistView.numOfPerformances, dbo.Country.name AS countryName, dbo.Artist.dateOfBirth
		FROM          dbo.Artist INNER JOIN
		              dbo.Country ON dbo.Artist.Country = dbo.Country.id INNER JOIN
				      dbo.AlbumsPerArtistView ON dbo.Artist.id = dbo.AlbumsPerArtistView.id INNER JOIN
					  dbo.PerformancesPerArtistView ON dbo.Artist.id = dbo.PerformancesPerArtistView.id
		WHERE (firstName LIKE '%'+@FirstName+'%') AND (lastName LIKE '%'+@LastName+'%') AND (ISNULL(name,'') LIKE '%'+@Country)
		GROUP BY dbo.Artist.id, dbo.Artist.firstName, dbo.Artist.lastName, dbo.Artist.dateOfBirth, dbo.Country.name, dbo.AlbumsPerArtistView.numOfAlbums, dbo.PerformancesPerArtistView.numOfPerformances
	END
-----------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_SearchSongs @UserName varchar(20), @SearchTime varchar(30), @artistID int
AS
	IF NOT EXISTS
	(select *
	from Search
	where username = @UserName and searchTime = @SearchTime)
	or NOT EXISTS
	(select *
	from Artist
	where id = @artistID) BEGIN
		PRINT 'Error: no such search OR artistId'
		SELECT TOP 0  dbo.Song.title as songName, ISNULL(dbo.Album.title,'') AS albumName, ISNULL(Artist_1.firstName,'') + ' ' + ISNULL(Artist_1.lastName,'') AS albumArtistFullName, dbo.Song.releaseDate, ISNULL(dbo.Song.genreName,'') as genreName, dbo.Song.length as 'length (sec)'
		FROM          dbo.Song INNER JOIN
		              dbo.PerformingArtist ON dbo.Song.id = dbo.PerformingArtist.songId INNER JOIN
			          dbo.Artist ON dbo.PerformingArtist.artistId = dbo.Artist.id LEFT OUTER JOIN
			          dbo.Artist AS Artist_1 INNER JOIN
			          dbo.Album ON Artist_1.id = dbo.Album.artistId ON dbo.Song.albumId = dbo.Album.id
		GROUP BY dbo.Song.title, dbo.Song.length, dbo.Song.releaseDate, dbo.Song.genreName, dbo.Album.title, Artist_1.firstName, Artist_1.lastName, dbo.Artist.id
	END
	ELSE BEGIN
		insert into SearchDetails(userName, searchTime, artistID)
		values (@UserName, @SearchTime, @artistID)
		SELECT        dbo.Song.title as songName, ISNULL(dbo.Album.title,'') AS albumName, ISNULL(Artist_1.firstName,'') + ' ' + ISNULL(Artist_1.lastName,'') AS albumArtistFullName, dbo.Song.releaseDate, ISNULL(dbo.Song.genreName,'') as genreName, dbo.Song.length as 'length (sec)'
		FROM          dbo.Song INNER JOIN
		              dbo.PerformingArtist ON dbo.Song.id = dbo.PerformingArtist.songId INNER JOIN
			          dbo.Artist ON dbo.PerformingArtist.artistId = dbo.Artist.id LEFT OUTER JOIN
			          dbo.Artist AS Artist_1 INNER JOIN
			          dbo.Album ON Artist_1.id = dbo.Album.artistId ON dbo.Song.albumId = dbo.Album.id
		WHERE        (dbo.Artist.id = @artistID)
		GROUP BY dbo.Song.title, dbo.Song.length, dbo.Song.releaseDate, dbo.Song.genreName, dbo.Album.title, Artist_1.firstName, Artist_1.lastName, dbo.Artist.id
	END
-----------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_GetCountries
AS
SELECT        name AS countryName
FROM          dbo.Country
GROUP BY name
-----------------------------------------------------------------------------------------------------------