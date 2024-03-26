using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.MediaControllersTests;

public class MediaControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly GroupsController _groupsController;
    private readonly RegisterController _registerController;
    private readonly MediaController _mediaController;
    private readonly UsersController _usersController;
    
    public MediaControllerTests()
    {
        _groupsController = new GroupsController(_context);
        _registerController = new RegisterController(_context);
        _mediaController = new MediaController(_context);
        _usersController = new UsersController(_context);
    }
    
    [Fact]
    public async void ItShould_successfully_load_media()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        // Act
        var actionResult = await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1, 1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotEmpty(_context.Media);
    }

    [Fact]
    public async void ItShould_fail_to_load_media()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 2, 1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
        Assert.Empty(_context.Media);
    }

    [Fact]
    public async void ItShould_successfully_get_media()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1, 1);
        
        // Act
        var actionResult = await _mediaController.GetMedia();
        
        // Assert
        Assert.NotEmpty(actionResult);
    }
    
    [Fact]
    public async void ItShould_successfully_get_media_by_mediaId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1, 1);
        
        // Act
        var actionResult = await _mediaController.GetMediaById(1);
        
        // Assert
        Assert.NotNull(actionResult.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_media_with_invalid_mediaId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1, 1);
        
        // Act
        var actionResult = await _mediaController.GetMediaById(2);
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Media not found", result?.Value);
        Assert.Null(actionResult.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_get_group_info_by_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1, 1);
        
        // Act
        var actionResult = await _groupsController.GetGroupInfoById(1, 1, 5);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotNull(result?.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_group_info_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1, 1);
        
        // Act
        var actionResult = await _groupsController.GetGroupInfoById(2, 1, 5);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
        Assert.Null(actionResult.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_group_info_with_invalid_ownerId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1, 1);
        await _usersController.DeleteUserAccount(1);
        
        // Act
        var actionResult = await _groupsController.GetGroupInfoById(1, 1, 5);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Owner not found", result?.Value);
        Assert.Null(actionResult.Value);
    }
}