module stdlow.io.file;
import core.stdc.stdio;
import core.stdc.stdlib;
import std.string;
import std.conv;

const BUFFER_SIZE = 8192;
struct fileData {
	void* data;
	size_t num_data;
}

@trusted fileData readFile(string filename) {
	auto file = fopen(filename.toStringz, "r");
	void* ptr_data;
	auto current_size = 0;
	auto offset = 0;
	if(file == null) {
		throw new StringException("Failed to open file: " ~ filename);
	}
	scope(exit) fclose(file);

	while(true) {
		ptr_data = realloc(ptr_data, current_size + BUFFER_SIZE);
		if (ptr_data == null) {
			throw new StringException("Memory allocation failed for: " ~ to!string(current_size + BUFFER_SIZE));
		}
		current_size += BUFFER_SIZE;
		auto current_data = fread(&ptr_data[offset], 1, BUFFER_SIZE, file);
		offset += current_data;
		if (current_data != BUFFER_SIZE) {
			size_t delta = BUFFER_SIZE - current_data;
			ptr_data = realloc(ptr_data, current_size - delta);
			if (ptr_data == null) {
				throw new StringException("Memory allocation failed for: " ~ to!string(current_size + BUFFER_SIZE));
			}
			break;
		}
	}
	
	if(ferror(file)) {
		throw new StringException("File read error!");
	}
	if (!feof(file)) {
			throw new StringException("File read error!");
	}
	fileData fd = {ptr_data, offset};
	return fd;
}

@trusted void writeFile(fileData filedata, string filename) {
	auto file = fopen(filename.toStringz, "w");
    auto ptr_data = filedata.data;
    auto current_size = 0;
	if(file == null) {
		throw new StringException("Failed to open file: " ~ filename);
	}
	scope(exit) fclose(file);
	
	do {
		auto delta = filedata.num_data - current_size;
		size_t buffer;
		if (delta < BUFFER_SIZE) {
			buffer = delta;
		} else {
			buffer = BUFFER_SIZE;
		}
		auto result = fwrite(ptr_data, 1, buffer, file);
		if (result < buffer) {
			throw new StringException("File write error");
		}
		current_size += buffer;
		ptr_data += buffer;
	} while (current_size != filedata.num_data);
}
