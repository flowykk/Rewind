using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Tests.UserControllersTests;

public class ChangeUserControllerTest
{
    private readonly DataContext _context = ContextGenerator.Generate();
    
    [Fact]
    public async void ItShould_successfully_change_user_name()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var nameRequest = new NameRequest() { Name = "newName" };

        // Act
        var actionResult = await changeUserController.ChangeName(1, nameRequest);
        
        // Assert
        var result = actionResult as ObjectResult;
        var changedUser = _context.Users.FirstOrDefault(u => u.Id == 1);
            
        Assert.Equal("200", result.StatusCode.ToString());
        
        Assert.NotNull(changedUser);
        Assert.Equal("newName", changedUser.UserName);
    }
    
    [Fact]
    public async void ItShould_fail_to_change_user_name()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var nameRequest = new NameRequest() { Name = "newName" };

        // Act
        var actionResult = await changeUserController.ChangeName(2, nameRequest);
        
        // Assert
        var result = actionResult as ObjectResult;
        var changedUser = _context.Users.FirstOrDefault(u => u.Id == 2);
            
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Null(changedUser);
    }
    
    [Fact]
    public async void ItShould_successfully_change_user_email()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var emailRequest = new EmailRequest() { Email = "new@new.new" };

        // Act
        var actionResult = await changeUserController.ChangeEmail(1, emailRequest);
        
        // Assert
        var result = actionResult as ObjectResult;
        var changedUser = _context.Users.FirstOrDefault(u => u.Id == 1);
            
        Assert.Equal("200", result.StatusCode.ToString());
        
        Assert.NotNull(changedUser);
        Assert.Equal("new@new.new", changedUser.Email);
    }
    
    [Fact]
    public async void ItShould_fail_to_change_user_email()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var emailRequest = new EmailRequest() { Email = "new@new.new" };

        // Act
        var actionResult = await changeUserController.ChangeEmail(2, emailRequest);
        
        // Assert
        var result = actionResult as ObjectResult;
        var changedUser = _context.Users.FirstOrDefault(u => u.Id == 2);
            
        Assert.Equal("400", result.StatusCode.ToString());
        
        Assert.Null(changedUser);
    }
}