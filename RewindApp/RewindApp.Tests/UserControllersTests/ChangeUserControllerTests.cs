using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Services;

namespace RewindApp.Tests.UserControllersTests;

public class ChangeUserControllerTests
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
        var changedUser = _context.Users.FirstOrDefault(u => u.UserName == "newName");
            
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
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("User not found", result.Value);
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
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("User not found", result.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_change_user_password()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        var userService = new UserService();
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var passwordRequest = new PasswordRequest() { Password = "qwerty" };

        // Act
        var actionResult = await changeUserController.ChangePassword(1, passwordRequest);
        
        // Assert
        var result = actionResult as ObjectResult;
        var changedUser = _context.Users.FirstOrDefault(u => u.Id == 1);
            
        Assert.Equal("200", result.StatusCode.ToString());
        
        Assert.NotNull(changedUser);
        Assert.Equal(userService.ComputeHash("qwerty"), changedUser.Password);
    }
    
    [Fact]
    public async void ItShould_fail_to_change_user_password()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        var userService = new UserService();
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var passwordRequest = new PasswordRequest() { Password = "qwerty" };

        // Act
        var actionResult = await changeUserController.ChangePassword(2, passwordRequest);
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("User not found", result.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_to_change_user_image()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Act
        var actionResult = await changeUserController.ChangeProfileImage(
            ContextHelper.BuildTestImageRequest(), 1);
        
        var result = actionResult as ObjectResult;
        var changedUser = _context.Users.FirstOrDefault(u => u.Id == 1);
        
        // Assert
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotNull(changedUser);
        Assert.Equal(
            "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=", 
            Convert.ToBase64String(changedUser.ProfileImage)
            );
    }
    
    [Fact]
    public async void ItShould_fail_to_change_user_image_with_invalid_userId()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        var changeUserController = new ChangeUserController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Act
        var actionResult = await changeUserController.ChangeProfileImage(
            ContextHelper.BuildTestImageRequest(), 2);
        
        var result = actionResult as ObjectResult;
        
        // Assert
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("User not found", result.Value);
    }
}