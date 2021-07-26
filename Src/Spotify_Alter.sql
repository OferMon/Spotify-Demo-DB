
---- Drop ----
Alter Table Resident Drop Constraint Ck_registeredUserEmail
Alter Table Resident Drop Constraint Ck_registeredUserPassword
Alter Table Resident Drop Constraint Ck_registeredUserType
Alter Table Resident Drop Constraint Ck_playlistCreateDate
Alter Table Resident Drop Constraint Ck_artistDateOfBirth
Alter Table Resident Drop Constraint Ck_albumReleaseDate
Alter Table Resident Drop Constraint Ck_songLength
Alter Table Resident Drop Constraint Ck_songReleaseDate
Alter Table Resident Drop Constraint Ck_albumNum


---- Check ----
-- RegisteredUser
Alter Table RegisteredUser Add Constraint Ck_registeredUserEmail Check (registeredUserEmail like '%_@__%.__%')
Alter Table RegisteredUser Add Constraint Ck_registeredUserPassword Check (len(RegisteredUserPassword) >= 5)
Alter Table RegisteredUser Add Constraint Ck_registeredUserType Check (registeredUserType in ('Free','Student','Premium'))

-- Playlist
Alter Table Playlist Add Constraint Ck_playlistCreateDate Check (playlistCreateDate <= getdate())
-- Artist
Alter Table Artist Add Constraint Ck_artistDateOfBirth Check (artistDateOfBirth <= getdate())
-- Album
Alter Table Album Add Constraint Ck_albumReleaseDate Check (albumReleaseDate <= getdate())
-- Song
Alter Table Song Add Constraint Ck_songLength Check (songLength > 60)
Alter Table Song Add Constraint Ck_songReleaseDate Check (songReleaseDate <= getdate())
Alter Table Song Add Constraint Ck_albumNum Check (albumNum > 0)
