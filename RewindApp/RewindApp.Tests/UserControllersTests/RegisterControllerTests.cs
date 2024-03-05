using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.UserControllersTests;

public class RegisterControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();

    [Fact]
    public async void ItShould_successfully_register_user()
    {
        // Arrange
        var registerController = new RegisterController(_context);

        // Act
        var actionResult = await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Assert
        var result = actionResult as ObjectResult;
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Users);
    }
    
    [Fact]
    public async void ItShould_fail_to_register_user()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Assert
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Users);
    }
    
    [Fact]
    public async void ItShould_successfully_check_if_user_exists_when_email_is_valid()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await registerController.CheckEmail("no@yandex.ru");

        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("200", result.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_fail_to_check_if_user_exists_when_email_is_invalid()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await registerController.CheckEmail("no@no.no");

        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
        //Assert.Throws<Exception>(() => actionResult);
    }
    
    [Fact]
    public async void ItShould_fail_to_check_if_user_exists()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await registerController.CheckEmail("test@test.test");

        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
    }
}