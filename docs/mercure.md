# Mercure

## Publication d'un message

Utiliser le `HubInterface` fourni :

```php
public function publish(HubInterface $hub): Response
{
    // ...
    
    $update = new Update(
        'https://localhost/test/1', # URL personnalisée sur laquelle envoyer le message
        json_encode(['status' => 'Good!'], JSON_THROW_ON_ERROR) # Message au format JSON à envoyer sur l'URL du dessus
    );

    $hub->publish($update);

    // ...
}
```

## Lire un message Mercure

Côté front, utiliser le JS ci-dessous pour réceptionner et lire le message :

```js
<script>
  const eventSource = new EventSource("{{ mercure('https://localhost/test/1')|escape('js') }}", {
    withCredentials: true /** Mettre à true si le message est privé */
  });
    
  eventSource.onmessage = event => {
    console.log(event.data);
  }
</script>
```
