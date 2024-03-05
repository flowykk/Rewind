using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.UserControllersTests;

public class UsersControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();

    [Fact]
    public async void ItShould_be_under_testing()
    {
        // Arrange
        var userController = new UsersController(_context);
        var registerController = new RegisterController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await userController.GetUsers();
        
        // Assert
        Assert.NotEmpty(actionResult);
    }
    
    [Fact]
    public async void ItShould_return_user_object_by_Id()
    {
        // Arrange
        var userController = new UsersController(_context);
        var registerController = new RegisterController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await userController.GetUserById(1);
    
        // Act
        Assert.NotNull(actionResult);
    }
    
    [Fact]
    public async void ItShould_return_user_object_by_Email()
    {
        // Arrange
        var userController = new UsersController(_context);
        
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var result = await userController.GetUserByEmail("test@test.test");
    
        // Act
        Assert.NotNull(result);
    }

    [Fact]
    public async void ItShould_successfully_delete_user()
    {
        // Arrange
        var userController = new UsersController(_context);
        var registerController = new RegisterController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await userController.DeleteUserAccount(1);

        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.Empty(_context.Users);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_user()
    {
        // Arrange
        var userController = new UsersController(_context);
        var registerController = new RegisterController(_context);
        
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        // Assert
        var actionResult = await userController.DeleteUserAccount(2);

        // Act
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Users);
    }
}