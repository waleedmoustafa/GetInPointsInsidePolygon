using Points.Api.DTOs;

namespace Points.Api.Configuration
{
    public interface IJsonFieldsSerializer
    {
        string Serialize(ISerializableObject objectToSerialize, string fields);
    }
}
