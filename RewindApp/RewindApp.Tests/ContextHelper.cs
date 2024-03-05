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
}