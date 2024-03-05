using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.UserControllersTests;

public class UsersControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    
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
}