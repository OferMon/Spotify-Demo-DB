-----------------------------------------------------------------------------------------------------------
select S.title, A.firstName+' '+A.lastName as 'Artist Name', year(PA.yearOfExecution) yearOfExecution,
	case
		when DATEDIFF(year, PA.yearOfExecution, getDate())<2 then 'Mainstream'
		when DATEDIFF(year, PA.yearOfExecution, getDate())<10 then 'New'
		when DATEDIFF(year, PA.yearOfExecution, getDate())<20 then 'Old'
		else 'Classic' end 'Contemporariness'
	from PerformingArtist PA, Song S, Artist A
	where PA.songId = S.id and PA.artistId = A.id and PA.yearOfExecution is not null
-----------------------------------------------------------------------------------------------------------
select A.title, sum(S.length) / 3600 'Total songs length (hours)'
	from Song S, Album A
	where S.albumId = A.id
	group by S.albumId, A.title
	having count(*) > 1 order by 'Total songs length (hours)' desc
-----------------------------------------------------------------------------------------------------------
select A.firstName+' '+A.lastName 'Artist Name'
	from Artist A
	where DATEDIFF(year, A.dateOfBirth, GETDATE())<=10
intersect
select A.firstName+' '+A.lastName 'Artist Name'
	from Artist A, PerformingArtist PA
	where A.id = PA.artistId and DATEDIFF(year, PA.yearOfExecution, GETDATE())<=10
	group by artistId, A.firstName, A.lastName
	having count(*)>1
except
select distinct A.firstName+' '+A.lastName 'Artist Name'
	from Artist A, Album AL
	where A.id = AL.artistId and DATEDIFF(year, AL.releaseDate, GETDATE())<=10
-----------------------------------------------------------------------------------------------------------
select S.genreName, sum(S.numberOfPlays) genreSumOfPlays,
	(select sum(S.numberOfPlays) from Song S) sumOfPlays,
	cast(sum(S.numberOfPlays)*1.0 / (select sum(S.numberOfPlays) from Song S) as decimal(5,2)) ratio
	from Song S, Genre G
	where S.genreName = G.name and S.id in 
		(select top 5 S1.id
		 from Song S1
		 where S1.genreName = G.name
		 order by S1.numberOfPlays desc)
	group by S.genreName
-----------------------------------------------------------------------------------------------------------
delete from PlaylistSong
where playlistId in (select PS.playlistId
					 from PlaylistSong PS
					 group by PS.playlistId
					 having count(*)<2)
-----------------------------------------------------------------------------------------------------------