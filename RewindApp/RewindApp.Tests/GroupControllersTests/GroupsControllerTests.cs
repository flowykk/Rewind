using Microsoft.AspNetCore.Mvc;
using MySqlX.XDevAPI.Common;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Responses;
using RewindApp.Views;
using RewindApp.Views.GroupViews;
using RewindApp.Views.MediaViews;

namespace RewindApp.Tests.GroupControllersTests;

public class GroupsControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly UsersController _usersController;
    private readonly GroupsController _groupsController;
    private readonly RegisterController _registerController;
    private readonly MediaController _mediaController;
    
    public GroupsControllerTests()
    {
        _usersController = new UsersController(_context);
        _groupsController = new GroupsController(_context);
        _registerController = new RegisterController(_context);
        _mediaController = new MediaController(_context);
    }
    
    [Fact]
    public async void ItShould_successfully_create_group()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotEmpty(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_create_group_because_of_invalid_ownerId()
    {
        // Arrange

        // Act
        var actionResult = await _groupsController.CreateGroup(ContextHelper.BuildInvalidOwnerIdCreateGroupRequest());
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
        Assert.Empty(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_successfully_get_groups()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.GetGroups();
        
        // Assert
        Assert.NotEmpty(actionResult);
    }

    [Fact]
    public async void ItShould_successfully_get_groups_by_userId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.GetGroupsByUser(1);
        var result = actionResult.Result as ObjectResult;
        var value = result?.Value as IEnumerable<GroupView>;
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotNull(value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_groups_by_invalid_userId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.GetGroupsByUser(2);
        var result = actionResult.Result as ObjectResult;
        var value = result?.Value as IEnumerable<GroupView>;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
        Assert.Null(value);
    }
    
    [Fact]
    public async void ItShould_successfully_add_user_to_group()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _registerController.Register(ContextHelper.BuildExtraUserRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.AddUserToGroup(1,2);
        var result = actionResult.Result as ObjectResult;
        var groups = await _groupsController.GetGroupsByUserAsync(2);
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotNull(groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_duplicated_user_to_group()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.AddUserToGroup(1,1);
        var result = actionResult.Result as ObjectResult;
        var groups = await _groupsController.GetGroupsByUserAsync(1);

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Single(groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_user_to_group_with_invalid_userId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.AddUserToGroup(1,3);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_user_to_group_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.AddUserToGroup(2,1);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }

    [Fact]
    public async void ItShould_successfully_delete_group()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.DeleteGroup(1);
        var result = actionResult as ObjectResult;
        var groups = await _groupsController.GetGroupsByUserAsync(1);
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Empty(groups);
        Assert.Empty(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_group_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.DeleteGroup(2);
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }

    [Fact]
    public async void ItShould_successfully_delete_user_from_group()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.DeleteUserFromGroup(1, 1);
        var result = actionResult as ObjectResult;
        var groups = await _groupsController.GetGroupsByUserAsync(1);
        var users = await _groupsController.GetUsersByGroupAsync(1);
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Empty(users);
        Assert.Empty(groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_user_from_group_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.DeleteUserFromGroup(2, 1);
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_user_from_group_with_invalid_userId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.DeleteUserFromGroup(1, 2);
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_get_users_by_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.GetUsersByGroup(1);
        var result = actionResult.Result as ObjectResult;
        var value = result?.Value as IEnumerable<UserView>;
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotNull(value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_users_by_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.GetUsersByGroup(2);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }

    [Fact]
    public async void ItShould_successfully_get_group_media_by_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildLoadMediaRequest(), 1, 1);

        // Act
        var actionResult = await _groupsController.GetMediaByGroup(1);
        var result = actionResult.Result as ObjectResult;
        var value = result?.Value as IEnumerable<MediaView>;

        // Assert
        Assert.NotNull(actionResult.Result);
        Assert.NotNull(value);
        Assert.NotEmpty(value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_group_media_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildLoadMediaRequest(), 1, 1);

        // Act
        var actionResult = await _groupsController.GetMediaByGroup(2);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }

    [Fact]
    public async void ItShould_successfully_get_group_info_by_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildLoadMediaRequest(), 1, 1);
        var group = await _groupsController.GetGroupById(1); 
        
        // Act
        var actionResult = await _groupsController.GetGroupInfoById(1, 1,5);
        var result = actionResult.Result as ObjectResult;
        var value = result?.Value as GroupInfoResponse;

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotNull(value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_group_info_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildLoadMediaRequest(), 1, 1);
        
        // Act
        var actionResult = await _groupsController.GetGroupInfoById(2, 2,5);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_group_info_with_invalid_ownerId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildLoadMediaRequest(), 1, 1);
        await _usersController.DeleteUser(1);
        
        // Act
        var actionResult = await _groupsController.GetGroupInfoById(1, 1,5);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Owner not found", result?.Value);
    }
}