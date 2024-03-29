using AutoFixture;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Requests.UserRequests;

namespace RewindApp.Tests;

public static class ContextHelper
{
    private static Fixture _fixture = new Fixture();
    public static UserRegisterRequest BuildTestRegisterRequest() 
    {
        return _fixture
            .Build<UserRegisterRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserRegisterRequest BuildExtraUserRegisterRequest()//int extraUserId) 
    {
        return _fixture
            .Build<UserRegisterRequest>()
            //.With(req => req.Id, extraUserId)
            .Create();
    }
    
    public static UserLoginRequest BuildTestLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidEmailLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "no@no.no")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidPasswordLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "no")
            .Create();
    }

    public static CreateGroupRequest BuildInvalidOwnerIdCreateGroupRequest()
    {
        return _fixture
            .Build<CreateGroupRequest>()
            .With(req => req.GroupName, "defaultName")
            .Create();
    }
    
    public static CreateGroupRequest BuildTestCreateGroupRequest()
    {
        return _fixture
            .Build<CreateGroupRequest>()
            .With(req => req.OwnerId, 1)
            .With(req => req.GroupName, "defaultName")
            .Create();
    }

    public static MediaRequest BuildTestImageRequest()
    {
        return _fixture
            .Build<MediaRequest>()
            .With(req => req.Object, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .With(req => req.TinyObject, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .Create();
    }
    
    public static TextRequest BuildDefaultNameRequest()
    {
        return _fixture.Create<TextRequest>();
    }
    
    public static TextRequest BuildNameRequest(string name)
    {
        return _fixture
            .Build<TextRequest>()
            .With(req => req.Text, name)
            .Create();
    }
}