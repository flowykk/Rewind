using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.TagControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.TagControllerTests;

public class TagsControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();

    [Fact]
    public async void ItShould_successfully_add_tag_to_media_by_mediaId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);

        var tagsController = new TagsController(_context);
        
        // Assert
        var actionResult = await tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1); 
        var result = actionResult as ObjectResult;
        var media = await mediaController.GetMediaById(1);
        
        // Act
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Tags);
        Assert.NotEmpty(media.Value.Tags);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_tag_to_media_with_invalid_mediaId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);

        var tagsController = new TagsController(_context);
        
        // Assert
        var actionResult = await tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 2); 
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Media not found", result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_duplicate_tag_to_media_by_mediaId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);

        var tagsController = new TagsController(_context);
        await tagsController.AddTag(ContextHelper.BuildNameRequest("test"), 1);
        
        // Assert
        var actionResult = await tagsController.AddTag(ContextHelper.BuildNameRequest("test"), 1); 
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Media already has such Tag", result.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_get_tags()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        var tagsController = new TagsController(_context);
        await tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1);
        
        // Act
        var actionResult = await tagsController.GetTags();
        
        // Assert
        Assert.NotEmpty(actionResult);
        Assert.NotEmpty(_context.Tags);
    }

    [Fact]
    public async void ItShould_successfully_get_media_tags_by_mediaId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        var tagsController = new TagsController(_context);
        await tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1);

        // Assert
        var actionResult = await tagsController.GetTagsByMediaId(1);
        var media = await mediaController.GetMediaById(1);

        // Act
        Assert.NotNull(actionResult.Value);
        Assert.NotEmpty(media.Value.Tags);
    }

    [Fact] public async void ItShould_fail_to_get_media_tags_with_invalid_mediaId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var mediaController = new MediaController(_context);
        await mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        var tagsController = new TagsController(_context);
        await tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1);

        // Assert
        var actionResult = await tagsController.GetTagsByMediaId(2);
        var result = actionResult.Result as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Media not found", result.Value);
    }
}