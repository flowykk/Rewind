using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Infrastructure.Data;

namespace RewindApp.Tests.UserControllersTests;

public class UsersControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly UsersController _userController;
    private readonly RegisterController _registerController;
    private readonly GroupsController _groupsController;
    private readonly MediaController _mediaController;

    public UsersControllerTests()
    {
        _userController = new UsersController(_context);
        _registerController = new RegisterController(_context);
        _groupsController = new GroupsController(_context);
        _mediaController = new MediaController(_context);
    }
    
    [Fact]
    public async void ItShould_successfully_get_users()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await _userController.GetUsers();
        
        // Assert
        Assert.NotEmpty(actionResult);
    }
    
    [Fact]
    public async void ItShould_successfully_get_user_by_valid_Id()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Act
        var actionResult = await _userController.GetUserById(1);
    
        // Assert
        Assert.NotNull(actionResult);
    }
    
    [Fact]
    public async void ItShould_successfully_get_user_by_valid_email()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Act
        var result = await _userController.GetUserByEmail("test@test.test");
    
        // Assert
        Assert.NotNull(result);
    }

    [Fact]
    public async void ItShould_successfully_delete_user_by_valid_Id()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Act
        var actionResult = await _userController.DeleteUser(1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Empty(_context.Users);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_user_with_invalid_Id()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Act
        var actionResult = await _userController.DeleteUser(2);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
        Assert.NotEmpty(_context.Users);
    }

    [Fact]
    public async void ItShould_successfully_get_empty_liked_media_by_user()
    {
        // Arrange
        await LoadMedia();
        
        // Assert
        var result = await _userController.GetLikedMediaByUser(1);

        // Act
        Assert.Empty(result);
    }
    
    [Fact]
    public async void ItShould_successfully_get_not_empty_liked_media_by_user()
    {
        // Arrange
        await LoadMedia();
        await _mediaController.LikeMedia(1, 1);
        
        // Assert
        var result = await _userController.GetLikedMediaByUser(1);

        // Act
        Assert.Single(result);
    }
    
    private async Task LoadMedia()
    {
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var user = await _userController.GetUserById(1);
        var group = await _groupsController.GetGroupById(1);
        
        await ContextHelper.LoadMedia(ContextHelper.BuildLoadMediaRequest(), _context, group!, user!);
    }
}