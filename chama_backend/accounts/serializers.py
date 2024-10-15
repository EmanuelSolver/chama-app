from rest_framework import serializers
from .models import CustomUser, Chama, ChamaMembership
from django.contrib.auth.hashers import make_password

class CustomUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=False)  # Make password optional
    chama = serializers.PrimaryKeyRelatedField(queryset=Chama.objects.all(), write_only=True)  # Expect chama ID in the request

    class Meta:
        model = CustomUser
        fields = ['first_name', 'last_name', 'username', 'email', 'national_id', 'mobile_no', 'user_role', 'password', 'chama']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        # Pop chama out of validated data
        chama = validated_data.pop('chama', None)
        
        # Set default password if not provided
        if 'password' not in validated_data:
            validated_data['password'] = '@Qwerty123'
        
        # Ensure the password is hashed before saving
        validated_data['password'] = make_password(validated_data['password'])
        
        # Create the CustomUser instance
        user = super().create(validated_data)

        # If a Chama is provided, create a ChamaMembership record
        if chama:
            ChamaMembership.objects.create(user=user, chama=chama)

        return user


class ChamaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chama
        fields = ['chama_name', 'location', 'registration_no', 'meet_schedule', 'day_or_date', 'admin']
