using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.UserControllers;
using RewindApp.Infrastructure.Data;

namespace RewindApp.Tests.UserControllersTests;

public class RegisterControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly RegisterController _registerController;
    
    public RegisterControllerTests()
    {
        _registerController = new RegisterController(_context);
    }

    [Fact]
    public async void ItShould_successfully_register_user()
    {
        // Arrange
            
        // Act
        var actionResult = await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotEmpty(_context.Users);
    }
    
    [Fact]
    public async void ItShould_fail_to_register_duplicated_user()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User with this email already exists!", result?.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_check_if_user_exists_when_email_is_valid()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await _registerController.CheckEmail("no@yandex.ru");
        var result = actionResult as ObjectResult;

        // Act
        Assert.Equal("200", result?.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_fail_to_check_if_user_exists_when_email_is_invalid()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await _registerController.CheckEmail("no@no.no");
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result?.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_fail_to_check_if_user_exists()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await _registerController.CheckEmail("test@test.test");
        var result = actionResult as ObjectResult;

        // Act
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("User is registered", result?.Value);
    }
}