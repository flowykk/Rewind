using MailKit.Security;
using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.GroupControllersTests;

public class GroupsControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    
    [Fact]
    public async void ItShould_successfully_create_group()
    {
        // Arrange
        var groupsController = new GroupsController(_context);
        
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Assert
        var actionResult = await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_create_group_because_of_invalid_ownerId()
    {
        // Arrange
        var groupsController = new GroupsController(_context);

        // Assert
        var actionResult = await groupsController.CreateGroup(ContextHelper.BuildInvalidOwnerIdCreateGroupRequest());
        
        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Empty(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_create_group_because_of_duplicate_group_name()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Assert
        var actionResult = await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Single(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_successfully_get_groups()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.GetGroups();
        
        // Assert
        Assert.NotEmpty(actionResult);
        Assert.NotEmpty(_context.Groups);
    }

    [Fact]
    public async void ItShould_successfully_get_groups_by_userId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.GetGroupsByUser(1);
        var result = actionResult.Value;

        // Assert
        Assert.NotNull(result);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_groups_by_invalid_userId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.GetGroupsByUser(2);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("User not found", result.Value);
        Assert.Null(actionResult.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_add_user_to_group()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await registerController.Register(ContextHelper.BuildExtraUserRegisterRequest(2));
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.AddUserToGroup(1,2);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotNull(groupsController.GetGroupsByUser(2).Result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_duplicated_user_to_group()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.AddUserToGroup(1,1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.NotNull(groupsController.GetGroupsByUser(1).Result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_user_to_group_with_invalid_userId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.AddUserToGroup(1,3);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("User not found", result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_user_to_group_with_invalid_groupId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await registerController.Register(ContextHelper.BuildExtraUserRegisterRequest(2));
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.AddUserToGroup(2,2);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Group not found", result.Value);
    }

    [Fact]
    public async void ItShould_successfully_delete_group()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Assert
        var actionResult = await groupsController.DeleteGroup(1);
        
        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.Empty(groupsController.GetGroupsByUser(1).Result.Value);
        Assert.Empty(_context.Groups);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_group_with_invalid_groupId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Assert
        var actionResult = await groupsController.DeleteGroup(2);
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Groups);
    }

    [Fact]
    public async void ItShould_successfully_delete_user_from_group()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Assert
        var actionResult = await groupsController.DeleteUserFromGroup(1, 1);
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.Empty(groupsController.GetGroupsByUser(1).Result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_user_from_group_with_invalid_groupId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Assert
        var actionResult = await groupsController.DeleteUserFromGroup(2, 1);
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Group not found", result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_user_from_group_with_invalid_userId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Assert
        var actionResult = await groupsController.DeleteUserFromGroup(1, 2);
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("User not found", result.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_get_users_by_groupId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.GetUsersByGroup(1);
        var result = actionResult.Value;

        // Assert
        Assert.NotNull(result);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_users_by_invalid_groupId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await groupsController.GetUsersByGroup(2);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Group not found", result.Value);
        Assert.Null(actionResult.Value);
    }
}