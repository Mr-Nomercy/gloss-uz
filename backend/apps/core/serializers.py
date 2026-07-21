from rest_framework import serializers


class StringPKModelSerializer(serializers.ModelSerializer):
    """Flutter models do `json['id'] as String` — every admin-facing
    serializer needs `id` (and any FK id it exposes) as a JSON string,
    not a number.
    """

    id = serializers.CharField(read_only=True)
