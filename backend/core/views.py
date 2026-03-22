from django.shortcuts import render
import json, uuid, base64, tempfile
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from pydub import AudioSegment
from django.core.files.base import ContentFile
import speech_recognition as sr


AudioSegment.converter = r"/usr/bin/ffmpeg"
AudioSegment.ffmpeg = r"/usr/bin/ffmpeg" 

@api_view(["POST"])
@permission_classes([AllowAny])
def receive_audio(request):
    data = json.loads(request.body)
    audio_file = decode_base64_file(data.get('audio'), prefix='voice')
    r = sr.Recognizer()
    with sr.AudioFile(audio_file) as source:
        audio = r.record(source)
        text = r.recognize_google(audio)
    if audio_file:
        return Response({"message": "Audio received successfully.", "text": text}, status=200)
    else:
        return Response({"error": "Invalid audio data."}, status=400)
    
    

def decode_base64_file(data, prefix='file'):
    try:
        import mimetypes
        fmt, b64str = data.split(';base64,')
        mime = fmt.replace('data:', '')
        ext = mimetypes.guess_extension(mime)

        if not ext:
            ext = '.' + fmt.split('/')[-1]

        decoded = base64.b64decode(b64str)

        if prefix == 'voice':
            with tempfile.NamedTemporaryFile(suffix=ext, delete=False) as temp_in:
                temp_in.write(decoded)
                temp_in.flush()

                audio = AudioSegment.from_file(temp_in.name)

            with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as temp_out:
                audio.export(temp_out.name, format='wav')

                with open(temp_out.name, 'rb') as f:
                    return ContentFile(
                        f.read(),
                        name=f"{prefix}_{uuid.uuid4().hex}.wav"
                    )

        return ContentFile(decoded, name=f"{prefix}_{uuid.uuid4().hex}{ext}")

    except Exception as e:
        print(f"Error decoding {prefix}: {e}")
        return None