# Rewind request's routes

## Group requests

#### GET:

1. **Get Groups**
   
   Route: ../api/groups

2. **Get Groups by User**
   
   Route:  ../api/groups/{userId}

3. **Get Users by Group**
   
   Route: ../api/groups/users/{groupId}

#### PUT:

1. **Remove User from Group**
   
   Route: ../api/groups/delete/{groupId}/{userId}

#### POST:

1. **Create Group**
   
   Route: ../api/groups/create

2. Add User to Group
   
   Route: ../api/groups/add/{groupId}/{userId}

#### DELETE:

1. **Delete Group**
   
   Route: ../api/groups/delete/20

## User requests

#### GET:

1) **Get all Users**
   
   Route ../api/users

2) **Get User by Id**
   
   Route: ../api/users/{userId}
   
   Returns:
   
   204 No Content (if user was not found)
   
   200 Ok: *User* user

3) **Get User Profile Image**
   
   Route: ../api/users/image/{userId}
   
   Returns:
   
   200 Ok: *byte[]* Image
   
   400 Bad Request: "User not found"

4) **Send Verification code on email**
   
   Route: ../api/users/{email}

5) **Check if Email exists in DB while Registration**
   
   Route: ../api/register/check-email/{email}
   
   Returns: 
   
   400 Bad Request: "User is registered"
   
   200 Ok: {verification code}, which was sended to email

6) **Check if Email exists in DB while Login**
   
   Route: ../api/login/check-email/{email}
   
   Returns:
   
   400 Bad Request: "User not registered"
   
   200 Ok: {userId}

#### POST:

1. **Register User**
   
   Route: ../api/register
   
   ```json
   body {
       "username": username,
       "email": email,
       "password": password
   }
   ```
   
   Returns:
   
   200 Ok: {userId}
   
   400 Bad Request: "User with this email already exists!"

2. **Login User**
   
   Route: ../api/login
   
   ```json
   body {
       "email": email,
       "password": password
   }
   ```

        Returns:

        200 Ok: {userId}

        400 Bad Request: "User not found"

        400 Bad Request: "Incorrect password"

#### PUT:

1. **Change Name**
   
   Route: ../api/change-user/name/{userId}
   
   ```json
   body {
       "username": newName
   }
   ```
   
   Returns:
   
   200 Ok: "Name changed"
   
   400 Bad Request: "User not found"

2. **Change Email**: 
   
   Route: ../api/change-user/email/{userId}
   
   ```json
   body { 
       "email": newEmail 
   }
   ```
   
   Returns:
   
   200 Ok: "Email changed"
   
   400 Bad Request: "User not found"

3. **Change Password**: 
   
   Route: ../api/change-user/password/{userId}
   
   ```json5
   body { 
       "password": password 
   }
   ```
   
   Returns:
   
   200 Ok: "Password changed"
   
   400 Bad Request: "User not found"

4. **Change Profile Image**: 
   
   Route: ../api/change-user/image/{userId}
   
   ```json5
   body { 
       "media": newImage - Byte[]
   }
   ```

   Returns:

   200 Ok: "Image changed"

   400 Bad Request: "User not found"

#### DELETE:

1. **Delete User by Id**
   
   Route: ../api/users/delete/{userId}
   
   Returns:
   
   - 200 Ok: "{userId}"
   
   - 400 Bad Request: "User not found"
