using AutoFixture;
using RewindApp.Requests.UserRequests;

namespace RewindApp.Tests;

public static class ContextHelper
{
    public static UserRegisterRequest BuildTestRegisterRequest() 
    {
        return new Fixture()
            .Build<UserRegisterRequest>()
            .With(req => req.Id, 1)
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildTestLoginRequest() 
    {
        return new Fixture()
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidEmailLoginRequest() 
    {
        return new Fixture()
            .Build<UserLoginRequest>()
            .With(req => req.Email, "no@no.no")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidPasswordLoginRequest() 
    {
        return new Fixture()
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "no")
            .Create();
    }
}