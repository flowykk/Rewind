# Rewind request's routes

## Media requests

#### GET:

1. **Get all Media**
   
   Route: ../api/media

2. **Get Media by Id**
   
   Route: ../api/media/{mediaId}
   
   Returns:
   
   - **200 Ok**: *byte[]* media
   
   - **400 Bad Request**: "Media not found"

#### POST:

1. #### **Load Media to Group**
   
   Route: ../api/media/load/{groupId}
   
   Returns:
   
   - **200 Ok**: "Media loaded"
   
   - **400 Bad Request**: "Group not found" 

## Tags requests

#### GET:

1. **Get all Tags**
   
   Route: ../api/tags

2. **Get Tags by Media Id**
   
   Route: ../api/tags/{mediaId}
   
   Returns:
   
   - **200 Ok**: *List(Media) media*
   
   - **400 Bad Request**: "Media not found"

#### POST:

1. **Add Tag to Media**
   
   Route: ../api/tags/add/{mediaId}
   
   Returns:
   
   - **200 Ok**: *Tag* tag
   
   - **400 Bad Request**: "Media not found"

## Group requests

#### GET:

1. **Get Groups**
   
   Route: ../api/groups

2. **Get Groups by User**
   
   Route:  ../api/groups/{userId}
   
   Returns:
   
   - **200 Ok**: *List(Group)* groups
   
   - **400 Bad Request**: "User not found"

3. **Get Users by Group**
   
   Route: ../api/groups/users/{groupId}
   
   Returns:
   
   - **200 Ok**: *List(User)* users
   
   - **400 Bad Request**: "Group not found"

4. **Get Group image**
   
   Route: ../api/groups/image/{groupId}
   
   Returns:
   
   - **200 Ok**: *byte[]* Image
   
   - **400 Bad Request**: "Group not found"

5. **Get Group Media**
   
   Route: ../api/groups/media/{groupId}
   
   Returns:
   
   - **200 Ok**: *List(Media)* Image
   
   - **400 Bad Request**: "Group not found"

#### PUT:

1. **Remove User from Group**
   
   Route: ../api/groups/delete/{groupId}/{userId}

2. **Change Group Name**
   
   Route: ../api/change-group/name/{groupId}
   
   ```
   body { 
       "media": newImage - Byte[]
   }
   ```
   
   Returns:
   
   - **200 Ok**: "Name changed"
   
   - **400 Bad Request**: "Group not found"

3. **Change Profile Image**:
   
   Route: ../api/change-group/image/{groupId}
   
   ```
   body { 
       "media": newImage - Byte[]
   }
   ```
   
   Returns:
   
   - **200 Ok**: "Image changed"
   
   - **400 Bad Request**: "User not found"

#### POST:

1. **Create Group**
   
   Route: ../api/groups/create
   
   ```
   body { 
       "OwnerId": ownerId,
       "GroupName": groupName
   }
   ```
   
   Returns:
   
   - **200 Ok**: "Group was created"
   
   - **400 Bad Request**: "User not found"
   
   - **400 Bad Request**: "Group '{request.GroupName}', created by User {userId} already exists"

2. **Add User to Group**
   
   Route: ../api/groups/add/{groupId}/{userId}
   
   Returns:
   
   - **200 Ok**: "Group was created"
   
   - **400 Bad Request**: "Group not found"
   
   - **400 Bad Request**: "User not found"
   
   - **400 Bad Request**: "Error occured"
   
   - **400 Bad Request**: "Group {groupId} already contains User {userId}"

#### DELETE:

1. **Delete Group**
   
   Route: ../api/groups/delete/20
   
   Returns:
   
   - **200 Ok**: "User {userId} was successfully removed from group {groupId}"
   
   - **400 Bad Request**: "Group not found"
   
   - **400 Bad Request**: "User not found"
   
   - **400 Bad Request**: "Error occured"

## User requests

#### GET:

1) **Get all Users**
   
   Route ../api/users

2) **Get User by Id**
   
   Route: ../api/users/{userId}
   
   Returns:
   
   - **204 No Content** (if user was not found)
   
   - **200 Ok**: *User* user

3) **Get User Profile Image**
   
   Route: ../api/users/image/{userId}
   
   Returns:
   
   - **200 Ok**: *byte[]* Image
   
   - **400 Bad Request**: "User not found"

4) **Send Verification code on email**
   
   Route: ../api/users/{email}

5) **Check if Email exists in DB while Registration**
   
   Route: ../api/register/check-email/{email}
   
   Returns: 
   
   - **200 Ok**: {verification code}, which was sended to email
   
   - **400 Bad Request**: "User is registered"
   
   - **400 Bad Request**: exception.Message

6) **Check if Email exists in DB while Login**
   
   Route: ../api/login/check-email/{email}
   
   Returns:
   
   - **200 Ok**: {userId}
   
   - **400 Bad Request**: "User not registered"

#### POST:

1. **Register User**
   
   Route: ../api/register
   
   ```
   body {
       "username": username,
       "email": email,
       "password": password
   }
   ```
   
   Returns:
   
   - **200 Ok**: {userId}
   
   - **400 Bad Request**: "User with this email already exists!"

2. **Login User**
   
   Route: ../api/login
   
   ```
   body {
       "email": email,
       "password": password
   }
   ```

        Returns:

        - **200 Ok**: {userId}

        - **400 Bad Request**: "User not found"

        - **400 Bad Request**: "Incorrect password"

#### PUT:

1. **Change Name**
   
   Route: ../api/change-user/name/{userId}
   
   ```
   body {
       "username": newName
   }
   ```
   
   Returns:
   
   - **200 Ok**: "Name changed"
   
   - **400 Bad Request**: "User not found"

2. **Change Email**: 
   
   Route: ../api/change-user/email/{userId}
   
   ```
   body { 
       "email": newEmail 
   }
   ```
   
   Returns:
   
   - **200 Ok**: "Email changed"
   
   - **400 Bad Request**: "User not found"

3. **Change Password**: 
   
   Route: ../api/change-user/password/{userId}
   
   ```
   body { 
       "password": password 
   }
   ```
   
   Returns:
   
   - **200 Ok**: "Password changed"
   
   - **400 Bad Request**: "User not found"

4. **Change Profile Image**: 
   
   Route: ../api/change-user/image/{userId}
   
   ```
   body { 
       "media": newImage - Byte[]
   }
   ```
   
   Returns:
   
   - **200 Ok**: "Image changed"
   
   - **400 Bad Request**: "User not found"

#### DELETE:

1. **Delete User by Id**
   
   Route: ../api/users/delete/{userId}
   
   Returns:
   
   - **200 Ok**: "{userId}"
   
   - **400 Bad Request**: "User not found"
