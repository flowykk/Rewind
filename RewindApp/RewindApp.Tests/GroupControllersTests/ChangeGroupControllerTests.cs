using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Tests.GroupControllersTests;

public class ChangeGroupControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly GroupsController _groupsController;
    private readonly RegisterController _registerController;
    private readonly ChangeGroupController _changeGroupController;
    
    public ChangeGroupControllerTests()
    {
        _groupsController = new GroupsController(_context);
        _registerController = new RegisterController(_context);
        _changeGroupController = new ChangeGroupController(_context);
    }
    
    [Fact]
    public async void ItShould_successfully_change_group_name()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        var nameRequest = new TextRequest() { Text = "newName" };

        // Act
        var actionResult = await _changeGroupController.ChangeName(nameRequest, 1);
        var result = actionResult as ObjectResult;
        
        var changedGroup = _context.Groups.FirstOrDefault(g => g.Name == "newName");
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        
        Assert.NotNull(changedGroup);
        Assert.Equal("newName", changedGroup?.Name);
    }
    
    [Fact]
    public async void ItShould_fail_to_change_group_name_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        var nameRequest = new TextRequest() { Text = "newName" };

        // Act
        var actionResult = await _changeGroupController.ChangeName(nameRequest, 2);
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_change_group_image()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        
        // Act
        var actionResult = await _changeGroupController.ChangeGroupImage(ContextHelper.BuildTestChangeImageRequest(), 1);
        var result = actionResult as ObjectResult;
        
        var changedGroup = _groupsController.GetGroupById(1).Result;
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        
        Assert.NotNull(changedGroup);
        Assert.Equal(
            "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=", 
            Convert.ToBase64String(changedGroup!.Image)
            );
    }
    
    [Fact]
    public async void ItShould_fail_to_change_group_image_with_invalid_groupId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        // Act
        var actionResult = await _changeGroupController.ChangeGroupImage(ContextHelper.BuildTestChangeImageRequest(), 2);
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Group not found", result?.Value);
    }
}