using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.MediaControllersTests;

public class MediaControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();

    [Fact]
    public async void ItShould_successfully_load_media()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);

        // Assert
        var actionResult = await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);

        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Media);
    }

    [Fact]
    public async void ItShould_fail_to_load_media()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);

        // Assert
        var actionResult = await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 2);
        var result = actionResult as ObjectResult;

        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Group not found", result.Value);
        Assert.Empty(_context.Media);
    }

    [Fact]
    public async void ItShould_successfully_get_media()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        // Act
        var actionResult = await mediaController.GetMedia();
        
        // Assert
        Assert.NotEmpty(actionResult);
        Assert.NotEmpty(_context.Media);
    }
    
    [Fact]
    public async void ItShould_successfully_get_media_by_mediaId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        // Act
        var actionResult = await mediaController.GetMediaById(1);
        
        // Assert
        Assert.NotNull(actionResult.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_get_media_with_invalid_mediaId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        // Act
        var actionResult = await mediaController.GetMediaById(2);
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Media not found", result.Value);
    }
}