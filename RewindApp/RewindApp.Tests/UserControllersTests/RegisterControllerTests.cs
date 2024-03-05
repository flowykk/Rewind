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
}