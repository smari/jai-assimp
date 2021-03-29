/*
 * AssImp bindings for Jai.
 *
 * For all documentation of data structures, members and such, refer to the AssImp header files
 * or AssImp documentation.
 *
 */

AISTRING_MAXLEN :: 1024;

AI_SCENE_FLAGS_INCOMPLETE :: 0x1;
AI_SCENE_FLAGS_VALIDATED :: 0x2;
AI_SCENE_FLAGS_VALIDATION_WARNING :: 0x4;
AI_SCENE_FLAGS_NON_VERBOSE_FORMAT :: 0x8;
AI_SCENE_FLAGS_TERRAIN :: 0x10;
AI_SCENE_FLAGS_ALLOW_SHARED :: 0x20;

AI_MAX_FACE_INDICES :: 0x7fff;
AI_MAX_BONE_WEIGHTS :: 0x7fffffff;
AI_MAX_VERTICES :: 0x7fffffff;
AI_MAX_FACES :: 0x7fffffff;
AI_MAX_NUMBER_OF_COLOR_SETS :: 0x8;
AI_MAX_NUMBER_OF_TEXTURE_COORDS :: 0x8;

HINTMAXTEXTURELEN :: 9;

aiVector2D :: Vector2;
aiVector3D :: Vector3;
aiMatrix4x4 :: Matrix4;
aiColor3D :: Vector3;
aiColor4D :: Vector4;
aiQuaternion :: Quaternion;

aiString :: struct {
    count           : u32;
    data            : [AISTRING_MAXLEN]u8;
}

to_string :: inline (ais: aiString) -> string {
    ss : string;
    ss.count = ais.count;
    ss.data = xx *ais.data;
    return ss;
}

to_string :: inline (ais: *aiString) -> string {
    ss : string;
    ss.count = ais.count;
    ss.data = xx *ais.data;
    return ss;
}

aiScene :: struct {
    mFlags          : u32;
    mRootNode       : *aiNode;
    mNumMeshes      : u32;
    mMeshes         : **aiMesh;
    mNumMaterials   : u32;
    mMaterials      : **aiMaterial;
    mNumAnimations  : u32;
    mAnimations     : **aiAnimation;
    mNumTextures    : u32;
    mTextures       : **aiTexture;
    mNumLights      : u32;
    mLights         : **aiLight;
    mNumCameras     : u32;
    mCameras        : **aiCamera;
    mMetaData       : *aiMetadata;
}

aiMetadataType :: enum u32 {
    AI_BOOL         :: 0;
    AI_INT32        :: 1;
    AI_UINT64       :: 2;
    AI_FLOAT        :: 3;
    AI_DOUBLE       :: 4;
    AI_AISTRING     :: 5;
    AI_AIVECTOR3D   :: 6;
    AI_META_MAX     :: 7;
}

aiMetadataEntry :: struct {
    mType           : aiMetadataType;
    mData           : *void;
}

aiMetadata :: struct {
    mNumProperties  : u32;
    mKeys           : *aiString;
    mValues         : *aiMetadataEntry;
}

to_string :: (t: aiMetadataEntry) -> string {
    using t;
    if mType == {
        case .AI_BOOL; 
            if << cast(*bool)mData == true {
                return "True";
            } else {
                return "False";
            }
        case .AI_INT32;
            return tprint("%", <<cast(*s32)mData);
        case .AI_UINT64;
            return tprint("%", <<cast(*u64)mData);
        case .AI_FLOAT;
            return tprint("%", <<cast(*float32)mData);
        case .AI_DOUBLE;
            return tprint("%", <<cast(*float64)mData);
        case .AI_AISTRING;
            return tprint("%", to_string(cast(*aiString)mData));
        case .AI_AIVECTOR3D;
            return tprint("{%, %, %}", (cast(*aiVector3D)mData).x, (cast(*aiVector3D)mData).y, (cast(*aiVector3D)mData).z);
        case;
            return "Unknown";
        
    }
}

aiNode :: struct {
    mName           : aiString;
    mTransformation : Matrix4;
    mParent         : *aiNode;
    mNumChildren    : u32;
    mChildren       : **aiNode;
    mNumMeshes      : u32;
    mMeshes         : *u32;
    mMetaData       : *aiMetadata;
}

aiMesh :: struct {
    mPrimitiveTypes : u32;
    mNumVertices    : u32;
    mNumFaces       : u32;
    mVertices       : *aiVector3D;
    mNormals        : *aiVector3D;
    mTangents       : *aiVector3D;
    mBitangents     : *aiVector3D;
    mColors         : [AI_MAX_NUMBER_OF_COLOR_SETS]*aiColor4D;
    mTextureCoords  : [AI_MAX_NUMBER_OF_TEXTURE_COORDS]*aiVector3D;
    mNumUVComponents: [AI_MAX_NUMBER_OF_TEXTURE_COORDS]u32;
    mFaces          : *aiFace;
    mNumBones       : u32;
    mBones          : **aiBone;
    mMaterialIndex  : u32;
    mName           : aiString;
    mNumAnimMeshes  : u32;
    mAnimMeshes     : **aiAnimMesh;
    mMethod         : u32;
    mAABB           : aiAABB;
}

aiAABB :: struct {
    mMin            : aiVector3D;
    mMax            : aiVector3D;
}

aiAnimMesh :: struct {
    mName           : aiString;
    mVertices       : *aiVector3D;
    mNormals        : *aiVector3D;
    mTangents       : *aiVector3D;
    mBitangents     : *aiVector3D;
    mColors         : [AI_MAX_NUMBER_OF_COLOR_SETS]*aiColor4D;
    mTextureCoords  : [AI_MAX_NUMBER_OF_TEXTURE_COORDS]*aiVector3D;
    mNumVertices    : u32;
    mWeight         : float32;
}

aiVertexWeight :: struct {
    mVertexId       : u32;
    mWeight         : float32;
}

aiFace :: struct {
    mNumIndices     : u32;
    mIndices        : *u32;
}

aiBone :: struct {
    mName           : aiString;
    mNumWeights     : u32;
    mWeights        : *aiVertexWeight;
    mOffsetMatrix   : aiMatrix4x4;
}

aiMaterial :: struct {
    mProperties     : **aiMaterialProperty;
    mNumProperties  : u32;
    mNumAllocated   : u32;
}

aiMaterialProperty :: struct {
    mKey            : aiString;
    mSemantic       : u32;
    mIndex          : u32;
    mDataLength     : u32;
    mType           : aiPropertyTypeInfo;
    mData           : *u8;
}

aiPropertyTypeInfo :: enum {
    aiPTI_Float     :: 0x1;
    aiPTI_Double    :: 0x2;
    aiPTI_String    :: 0x3;
    aiPTI_Integer   :: 0x4;
    aiPTI_Buffer    :: 0x5;
}


aiAnimation :: struct {
    mName           : aiString;
    mDuration       : float64;
    mTicksPerSecond : float64;
    mNumChannels    : u32;
    mChannels       : **aiNodeAnim;
    mNumMeshChannels: u32;
    mMeshChannels   : **aiMeshAnim;
    mNumMorphMeshChannels: u32;
    mMorphMeshChannels: **aiMeshMorphAnim;
}

aiNodeAnim :: struct {

}

aiMeshAnim :: struct {
    mNodeName       : aiString;
    mNumPostitionKeys: u32;
    mPositionKeys   : *aiVectorKey;
    mNumRotationKeys: u32;
    mRotationKeys   : *aiQuatKey;
    mNumScalingKeys : u32;
    mScalingKeys    : *aiVectorKey;
    mPreState       : aiAnimBehaviour;
    mPostState      : aiAnimBehaviour;
}

aiAnimBehaviour :: enum u32 {
    aiAnimBehaviour_DEFAULT  :: 0x0;
    aiAnimBehaviour_CONSTANT :: 0x1;
    aiAnimBehaviour_LINEAR   :: 0x2;
    aiAnimBehaviour_REPEAT   :: 0x3;
}

aiVectorKey :: struct {
    mTime           : float64;
    mValue          : aiVector3D;
}

aiQuatKey :: struct {
    mTime           : float64;
    mValue          : aiQuaternion;
}

aiMeshMorphAnim :: struct {
    mName           : aiString;
    mNumKeys        : u32;
    mKeys           : *aiMeshMorphKey;
}

aiMeshMorphKey :: struct {
    mTime           : float64;
    mValues         : *u32;
    mWeights        : *float64;
    mNumValuesAndWeights : u32;
}

aiTexture :: struct {
    mWidth          : u32;
    mHeight         : u32;
    achFormatHint   : [HINTMAXTEXTURELEN]u8;
    pcData          : *aiTexel;
    mFileName       : aiString;
}

aiTexel :: struct {
    b               : u8;
    g               : u8;
    r               : u8;
    a               : u8;   
}

aiLight :: struct {
    mName           : aiString;
    mType           : aiLightSourceType;
    mPosition       : aiVector3D;
    mDirection      : aiVector3D;
    mUp             : aiVector3D;
    mAttenuationConstant : float32;
    mAttenuationLinear   : float32;
    mAttenuationQuadratic: float32;
    mColorDiffuse   : aiColor3D;
    mColorSpecular  : aiColor3D;
    mColorAmbient   : aiColor3D;
    mAngleInnerCone : float32;
    mSize           : aiVector2D;
}

aiLightSourceType :: enum {
    aiLightSource_UNDEFINED     :: 0x0;
    aiLightSource_DIRECTIONAL   :: 0x1;
    aiLightSource_POINT         :: 0x2;
    aiLightSource_SPOT          :: 0x3;
    aiLightSource_AMBIENT       :: 0x4;
    aiLightSource_AREA          :: 0x5;
}

aiCamera :: struct {
    mName           : aiString;
    mPosition       : aiVector3D;
    mUp             : aiVector3D;
    mLookAt         : aiVector3D;
    mHorizontalFOV  : float32;
    mClipPlaneNear  : float32;
    mClipPlaneFar   : float32;
    mAspect         : float32;
}

aiImportFile     :: (pFile: *u8, pFlags: u32) -> *aiScene #foreign assimp;
aiGetErrorString :: () -> *u8 #foreign assimp;
aiReleaseImport  :: (pScene: *aiScene) #foreign assimp;

#scope_file
#import "Math";
#import "Basic";
assimp :: #foreign_system_library "libassimp";
