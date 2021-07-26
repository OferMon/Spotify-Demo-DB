-----------------------------------------------------------------------------------------------------------
CREATE FUNCTION songsAmount (@ArtistId int)
RETURNS int
AS BEGIN
	DECLARE @Total int
		select @Total = count(*)
		from PerformingArtist
		where artistId = @ArtistId
	RETURN @Total
End
-----------------------------------------------------------------------------------------------------------
CREATE FUNCTION albums (@Ryear int, @numOfSongs int)
RETURNS table
AS return
	select A.title as 'Album Title', Ar.firstName + ' ' + Ar.lastName as 'ArtistName', A.releaseDate
	from Album A, Artist Ar
	where A.artistId = Ar.id and year(A.releaseDate) >= @Ryear
	INTERSECT
	select A.title as 'Album Title', Ar.firstName + ' ' + Ar.lastName as 'ArtistName', A.releaseDate
	from Album A, Artist Ar
	where A.artistId = Ar.id and dbo.songsAmount(Ar.id) >= @numOfSongs
-----------------------------------------------------------------------------------------------------------
create Trigger refreshAlbums
	on Song
	after delete as
begin
	declare @albumId int
	select @albumId = deleted.albumId
	from deleted
	if @albumId is not null
	and
	(select count(*)
	from Song
	where albumId = @albumId) = 0
		delete from album where id = @albumId
end
-----------------------------------------------------------------------------------------------------------
create procedure topPlaylist
	@inDb nvarchar(1)
as
	declare @playlistId smallint, @songId smallint
	if (@inDb = 'Y')
	begin
		select @playlistId = id
		from Playlist
		where userName = 'System' and title = 'Top Songs'
		update Playlist
		set createDate = GETDATE()
		where id = @playlistId
		delete from PlaylistSong where playlistId = @playlistId
	end
	else if (@inDb = 'N')
		begin
			insert into Playlist (id, title, userName, createDate,description) values ((SELECT ISNULL(MAX(id)+1,0) FROM Playlist WITH(SERIALIZABLE,UPDLOCK)), 'Top Songs', 'System', GETDATE(), 'Top 10 songs')
		end
	else
		begin
			print('Please enter Y/N only!')
			return
		end
	select @playlistId = id
	from Playlist
	where userName = 'System' and title = 'Top Songs'
	select top 10 id
	into #tempTable
	from Song
	where DATEDIFF(year, releaseDate, GETDATE()) <= 10
	order by numberOfPlays desc
	declare cursor_id CURSOR
		FOR SELECT id
		FROM #tempTable
	OPEN cursor_id
	FETCH NEXT FROM cursor_id INTO @songId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		insert into PlaylistSong (playlistId, songId) values (@playlistId,@songId)
		FETCH NEXT FROM cursor_id INTO @songId
	end
	CLOSE cursor_id
	DEALLOCATE cursor_id
-----------------------------------------------------------------------------------------------------------