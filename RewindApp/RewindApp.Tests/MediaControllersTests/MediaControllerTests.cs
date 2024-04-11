using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Domain.Views.MediaViews;
using RewindApp.Infrastructure.Data;

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
        await LoadMedia();

        // Assert
        Assert.NotEmpty(_context.Media);
    }
    
    [Fact]
    public async void ItShould_successfully_unload_media()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.UnloadMediaFromGroup(1, 1);
        var result = actionResult as ObjectResult;
        var group = await _groupsController.GetGroupById(1);

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Empty(_context.Media);
        Assert.Empty(group!.Media);
    }
    
    [Fact]
    public async void ItShould_fail_to_unload_media_with_invalid_mediaId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.UnloadMediaFromGroup(2, 1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Media not found", result?.Value);
        Assert.NotEmpty(_context.Media);
    }
    
    [Fact]
    public async void ItShould_fail_to_unload_media_with_invalid_groupId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.UnloadMediaFromGroup(1, 2);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
        Assert.NotEmpty(_context.Media);
    }

   /* [Fact]
    public async void ItShould_fail_to_load_media()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _mediaController.LoadMediaToGroup(ContextHelper.BuildLoadMediaRequest(), 2, 1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
        Assert.Empty(_context.Media);
    }*/

    [Fact]
    public async void ItShould_successfully_get_media()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.GetMedia();
        
        // Assert
        Assert.NotEmpty(actionResult);
    }
    
    [Fact]
    public async void ItShould_successfully_get_media_by_mediaId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.GetMediaById(1);
        
        // Assert
        Assert.NotNull(actionResult);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_media_with_invalid_mediaId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.GetMediaById(2);
        
        // Assert
        Assert.Null(actionResult);
    }
    
    [Fact]
    public async void ItShould_successfully_like_media()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.LikeMedia(1, 1);
        var result = actionResult as ObjectResult;
        var user = await _usersController.GetUserById(1);

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Equal("liked", result?.Value);
        Assert.NotEmpty(user!.Media);
    }
    
    [Fact]
    public async void ItShould_fail_to_like_media_with_invalid_mediaId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.LikeMedia(1, 2);
        var result = actionResult as ObjectResult;
        var user = await _usersController.GetUserById(1);

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Media not found", result?.Value);
        Assert.Empty(user!.Media);
    }
    
    [Fact]
    public async void ItShould_fail_to_like_media_with_invalid_userId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.LikeMedia(2, 1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_unlike_media()
    {
        // Arrange
        await LoadMedia();
        await _mediaController.LikeMedia(1, 1);
        
        // Act
        var actionResult = await _mediaController.UnlikeMedia(1, 1);
        var result = actionResult as ObjectResult;
        var user = await _usersController.GetUserById(1);

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Equal("unliked", result?.Value);
        Assert.Empty(user!.Media);
    }
    
    [Fact]
    public async void ItShould_fail_to_unlike_media_with_invalid_mediaId()
    {
        // Arrange
        await LoadMedia();
        await _mediaController.LikeMedia(1, 1);
        
        // Act
        var actionResult = await _mediaController.LikeMedia(1, 2);
        var result = actionResult as ObjectResult;
        var user = await _usersController.GetUserById(1);

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Media not found", result?.Value);
        Assert.NotEmpty(user!.Media);
    }
    
    [Fact]
    public async void ItShould_fail_to_unlike_media_with_invalid_userId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.UnlikeMedia(2, 1);
        var result = actionResult as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_get_media_info()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.GetMediaInfoById(1, 1);
        var result = actionResult.Result as ObjectResult;
        var value = result?.Value as LargeMediaInfoResponse;

        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotNull(value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_media_info_with_invalid_mediaId()
    {
        // Arrange
        await LoadMedia();
        
        // Act
        var actionResult = await _mediaController.GetMediaInfoById(2, 1);
        var result = actionResult.Result as ObjectResult;

        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Media not found", result?.Value);
    }

    private async Task LoadMedia()
    {
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var user = await _usersController.GetUserById(1);
        var group = await _groupsController.GetGroupById(1);

        await ContextHelper.LoadMedia(ContextHelper.BuildLoadMediaRequest(), _context, group!, user!);
    }
}