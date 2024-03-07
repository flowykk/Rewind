using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Tests.GroupControllersTests;

public class ChangeGroupControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    
    [Fact]
    public async void ItShould_successfully_change_group_name()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        var changeGroupController = new ChangeGroupController(_context);
        
        var nameRequest = new NameRequest() { Name = "newName" };

        // Act
        var actionResult = await changeGroupController.ChangeName(1, nameRequest);
        
        var result = actionResult as ObjectResult;
        var changedGroup = _context.Groups.FirstOrDefault(g => g.Name == "newName");
        
        // Assert
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotNull(changedGroup);
        Assert.Equal("newName", changedGroup.Name);
    }
    
    [Fact]
    public async void ItShould_fail_to_change_group_name_with_invalid_groupId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        var changeGroupController = new ChangeGroupController(_context);
        
        var nameRequest = new NameRequest() { Name = "newName" };

        // Act
        var actionResult = await changeGroupController.ChangeName(2, nameRequest);
        
        var result = actionResult as ObjectResult;
        var changedGroup = _context.Groups.FirstOrDefault(g => g.Name == "newName");
        
        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Null(changedGroup);
    }
    
    [Fact]
    public async void ItShould_successfully_change_group_image()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        var changeGroupController = new ChangeGroupController(_context);

        // Assert
        var actionResult = await changeGroupController.ChangeGroupImage(
            ContextHelper.BuildTestImageRequest(), 1);

        var result = actionResult as ObjectResult;
        var changedGroup = groupsController.GetGroupById(1).Result;
        
        // Act
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotNull(changedGroup);
        Assert.Equal(
            "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=", 
            Convert.ToBase64String(changedGroup.Image)
            );
    }
    
    [Fact]
    public async void ItShould_fail_to_change_group_image_with_invalid_groupId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        var groupsController = new GroupsController(_context);
        await groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        var changeGroupController = new ChangeGroupController(_context);

        // Assert
        var actionResult = await changeGroupController.ChangeGroupImage(
            ContextHelper.BuildTestImageRequest(), 2);

        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
    }
}