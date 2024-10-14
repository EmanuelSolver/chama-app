from rest_framework import generics
from .models import CustomUser, Chama
from .serializers import CustomUserSerializer, ChamaSerializer
from django.contrib.auth import authenticate
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework import status
class RegisterUserView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer

class RegisterChamaView(generics.CreateAPIView):
    queryset = Chama.objects.all()
    serializer_class = ChamaSerializer


class LoginView(generics.GenericAPIView):
    serializer_class = CustomUserSerializer

    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')
        
        # Authenticate the user
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            # User is authenticated, return user details
            user_data = {
                'first_name': user.first_name,
                'last_name': user.last_name,
                'username': user.username,
                'email': user.email,
                'national_id': user.national_id,
                'mobile_no': user.mobile_no,
                'user_role': user.user_role  # Include user role
            }
            return Response({'message': 'Login successful', 'user': user_data}, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)