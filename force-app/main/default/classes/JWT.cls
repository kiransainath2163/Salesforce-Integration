/**
 * @description       :
 * @author            : Amit Singh
 * @group             :
 * @last modified on  : 12-30-2020
 * @last modified by  : Amit Singh
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   12-30-2020   Amit Singh   Initial Version
 **/
public class JWT {
    public String alg { get; set; } // Algorithm
    public String iss { get; set; } // issuer
    public String sub { get; set; } // subject
    public String aud { get; set; } // audiance
    public String exp { get; set; } // expirations
    public String iat { get; set; } // issued at
    public Map<String, String> claims { get; set; }
    public Integer validFor { get; set; } // the access token is valid up to seconds
    public String cert { get; set; } // certificate name
    public String pkcs8 { get; set; } // private key Contents
    public String privateKey { get; set; } // will be used in case of HS256 algorithm

    public static final String HS256 = 'HS256';
    public static final String RS256 = 'RS256';
    public static final String NONE = 'none';

    public JWT(String alg) {
        this.alg = alg;
        this.validFor = 3600;
    }

    public String assertion() {
        String jwt = '';
        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject(); // {
        header.writeStringField('alg', this.alg);
        header.writeEndObject(); // }
        String encodedHeader = base64URLencode(
            Blob.valueOf(header.getAsString())
        );
        // {alg :"",typ :''}

        JSONGenerator body = JSON.createGenerator(false);
        body.writeStartObject(); // {
        body.writeStringField('iss', this.iss);
        body.writeStringField('sub', this.sub);
        body.writeStringField('aud', this.aud);
        Long rightNow = (dateTime.now().getTime() / 1000) + 1;
        body.writeNumberField('iat', rightNow);
        body.writeNumberField('exp', (rightNow + validFor));
        if (claims != null) {
            for (String claim : claims.keySet()) {
                body.writeStringField(claim, claims.get(claim));
            }
        }

        body.writeEndObject(); // }
        jwt =
            encodedHeader +
            '.' +
            base64URLencode(Blob.valueOf(body.getAsString()));

        if (this.alg == HS256) {
            Blob key = EncodingUtil.base64Decode(privateKey);
            Blob signature = Crypto.generateMac(
                'hmacSHA256',
                Blob.valueof(jwt),
                key
            );
            jwt += '.' + base64URLencode(signature);
        } else if (this.alg == RS256) {
            Blob signature = null;

            if (cert != null) {
                signature = Crypto.signWithCertificate(
                    'rsa-sha256',
                    Blob.valueOf(jwt),
                    cert
                );
            } else {
                Blob privateKey = EncodingUtil.base64Decode(pkcs8);
                signature = Crypto.sign(
                    'rsa-sha256',
                    Blob.valueOf(jwt),
                    privateKey
                );
            }
            jwt += '.' + base64URLencode(signature);
        } else if (this.alg == NONE) {
            jwt += '.';
        }
        return jwt;
    }

    public String base64URLencode(Blob input) {
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while (output.endsWith('=')) {
            output = output.subString(0, output.length() - 1);
        }
        return output;
    }
}
