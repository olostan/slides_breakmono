public override async Task ListFeatures(Rectangle request,
    Grpc.Core.IServerStreamWriter<Feature> responseStream,
    Grpc.Core.ServerCallContext context)
{
    var responses = features.FindAll(
        (feature) =>
            feature.Exists() && request.Contains(feature.Location)
    );
    foreach (var response in responses)
    {
        await responseStream.WriteAsync(response);
    }
}