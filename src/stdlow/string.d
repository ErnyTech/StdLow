module stdlow.string;
import core.stdc.string;

@trusted H memccpy(T, H)(H dest, const H src, T needle, size_t size) {
    char* to_needle_ptr;
    auto dest_size = memchr(to_needle_ptr, cast(char*) src, needle, size);
    cast(void) memcpy(dest, src, dest_size);
    if (dest_size == size) {
        return null;
    }
    
    return to_needle_ptr++;
}

@trusted H memchr(T, H)(const H s, T needle, size_t size) {
	H return_ptr;
	memchr(return_ptr, s, needle, size);
	return return_ptr;
}

@trusted size_t memchr(T, H)(out H return_ptr, const H s, T needle, size_t size) {
	if (size) {
		auto str_ptr = cast(const char*) s;
		for(int i = 0; i < size; i++) {
			if (str_ptr[i] == cast(char) needle) {
				return_ptr = cast(H) (&str_ptr[i]);
				return i;
			}
		}
	}
	
	return size;
}

@trusted H memrchr(T, H)(const H s, T needle, size_t size) {
	H return_ptr;
	memrchr(return_ptr, s, needle, size);
	return return_ptr;
}

@trusted size_t memrchr(T, H)(out H return_ptr, const H s, T needle, size_t size) {
    	if (size) {
		auto str_ptr = cast(char*) s + size;
		
		for(int i = 0; i < size; i++) {
            if(*str_ptr == cast(char) needle) {
                return_ptr = cast(H) (str_ptr);
                return size - i;
            }
            str_ptr--;
		}
	}
	
	return size;
}

@trusted int memcmp(T)(const T s1, const T s2, size_t size) {
	if(size) {
		auto s1_str = cast(char*) s1;
		auto s2_str = cast(char*) s2;
		
		while(size-- > 0) {
			if(*s1_str++ != *s2_str++) {
				return s1_str[-1] < s2_str[-1] ? -1 : 1;
			}
		}
	}

	return 0;	
}

@trusted H memcpy(H)(H dest, const H src, size_t len) {
    auto return_ptr = core.stdc.string.memcpy(cast(void*) dest, cast(void*) src, len);
    return cast(H) return_ptr;
}

@trusted H memmem(T, H)(H haystack_ptr, size_t size, const T needle) {
	H return_ptr;
	memmem(return_ptr, haystack_ptr, size, needle);
	return return_ptr;
}

@trusted size_t memmem(T, H)(out H return_ptr, const H haystack_ptr, size_t size, const T needle) {
	auto haystack = cast(char*) haystack_ptr;
	auto haystack_last = haystack_ptr + size;
	char* current_ptr;
	auto last_ptr = haystack + size - needle.length;
	
	if (size == 0) {
		return 0;
	}
	
	if (needle.length == 0) {
		return 0;
	}
	
	if (size < needle.length) {
		return 0;
	}
	
	if (needle.length == 1) {
		return_ptr = cast(H) memchr(haystack_ptr, cast(int) needle[0], size);
		auto before_size = haystack_last - return_ptr;
		return size - before_size;
	}
	
	for(current_ptr = haystack; current_ptr < last_ptr; current_ptr++) {
		if(current_ptr[0] == needle[0] && memcmp(current_ptr, cast(void*) needle, needle[0].sizeof * needle.length) == 0) {
			return_ptr = current_ptr;
			auto before_size = haystack_last - return_ptr;
			return size - before_size; 
		}
	}
	
	return size;
}


@trusted H memmove(H)(H dest, const H src, size_t len) {
    auto return_ptr = core.stdc.string.memmove(cast(void*) dest, cast(void*) src, len);
    return cast(H) return_ptr;
} 

@trusted H memset(H)(H dest, const H src, size_t len) {
    auto return_ptr = core.stdc.string.memset(cast(void*) dest, cast(void*) src, len);
    return cast(H) return_ptr;
}
