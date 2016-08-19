--光波分光
--Cipher Spectrum
--Scripted by Eerie Code
function c100911069.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c100911069.target)
    e1:SetOperation(c100911069.activate)
    c:RegisterEffect(e1)
    if not c100911069.global_check then
        c100911069.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_LEAVE_FIELD_P)
        ge1:SetOperation(c100911069.checkop)
        Duel.RegisterEffect(ge1,tp)
    end
end

function c100911069.checkfil(c,tp)
    return c:IsSetCard(0xe5) and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:GetOverlayCount()>0
end
function c100911069.checkop(e,tp,eg,ep,ev,re,r,rp)
    if not eg then return end
    local sg=eg:Filter(c100911069.checkfil,nil,tp)
    local tc=sg:GetFirst()
    while tc do
        tc:RegisterFlagEffect(100911069,RESET_EVENT+0x1fe0000-EVENT_TO_GRAVE,0,1)
        tc=sg:GetNext()
    end
end

function c100911069.cfil(c,e,tp)
    return c:GetFlagEffect(100911069)~=0 and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(c100911069.fil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c100911069.fil(c,e,tp,cd)
    return c:IsType(TYPE_XYZ) and c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100911069.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return eg:IsContains(chkc) and c100911069.cfil(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and eg:IsExists(c100911069.cfil,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=eg:FilterSelect(tp,c100911069.cfil,1,1,nil,e,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100911069.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=Duel.SelectMatchingCard(tp,c100911069.fil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
        if g2:GetCount()>0 then
            Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
