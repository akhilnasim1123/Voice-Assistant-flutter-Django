from django.shortcuts import render


from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny




@api_view(["POST"])
@permission_classes([AllowAny])
def receive_audio(request):
    audio_file = request.FILES.get('audio')
    if audio_file:
        return Response({"message": "Audio file received successfully."}, status=200)
    else:
        return Response({"error": "No audio file provided."}, status=400)