using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.GroupControllersTests;

public class GroupsControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly GroupsController _groupsController;
    private readonly RegisterController _registerController;
    private readonly MediaController _mediaController;
    
    public GroupsControllerTests()
    {
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
        var result = actionResult as ObjectResult;
        
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
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
        Assert.Empty(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_create_group_because_of_duplicate_group_name()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group 'defaultName', created by User 1 already exists", result?.Value);
        Assert.Single(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_successfully_get_groups()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.GetGroups("");
        
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
        var result = actionResult.Value;

        // Assert
        Assert.NotNull(result);
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

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
        Assert.Null(actionResult.Value);
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
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotNull(_groupsController.GetGroupsByUser(2).Result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_duplicated_user_to_group()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.AddUserToGroup(1,1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group 1 already contains User 1", result?.Value);
        Assert.Single(_groupsController.GetUsersByGroup(1).Result.Value!);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_user_to_group_with_invalid_userId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.AddUserToGroup(1,3);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
        Assert.Single(_groupsController.GetUsersByGroup(1).Result.Value!);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_user_to_group_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _groupsController.AddUserToGroup(2,1);
        var result = actionResult as ObjectResult;

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
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Empty(_groupsController.GetGroupsByUser(1).Result.Value!);
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
        Assert.NotEmpty(_context.Groups);
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
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Empty(_groupsController.GetGroupsByUser(1).Result.Value!);
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
        var result = actionResult.Value;

        // Assert
        Assert.NotNull(result);
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
        Assert.Null(actionResult.Value);
    }

    [Fact]
    public async void ItShould_successfully_get_group_media_by_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);

        // Act
        var actionResult = await _groupsController.GetMediaByGroupId(1);
        var group = await _groupsController.GetGroupById(1);

        // Assert
        Assert.NotNull(actionResult.Value);
        Assert.NotEmpty(group!.Media);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_group_media_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);

        // Act
        var actionResult = await _groupsController.GetMediaByGroupId(2);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
        Assert.Null(actionResult.Value);
    }
}