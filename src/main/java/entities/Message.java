package entities;

import lombok.Builder;
import lombok.Data;
@Builder
@Data
public class Message {
    private  String name;
    private  String text;
}
