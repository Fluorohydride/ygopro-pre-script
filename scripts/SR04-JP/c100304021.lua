--ロストワールド
--Lost World
--Script by mercury233
function c100304021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c100304021.atktg)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100304021,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c100304021.tkcon)
	e4:SetTarget(c100304021.tktg)
	e4:SetOperation(c100304021.tkop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(c100304021.tgcon)
	e6:SetTarget(c100304021.tglimit)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c100304021.reptg)
	e7:SetValue(c100304021.repval)
	e7:SetOperation(c100304021.repop)
	c:RegisterEffect(e7)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e7:SetLabelObject(g)
end
function c100304021.atktg(e,c)
	return not c:IsRace(RACE_DINOSAUR)
end
function c100304021.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DINOSAUR)
end
function c100304021.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100304021.cfilter,1,nil,tp)
end
function c100304021.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100304121,0,0x4011,0,0,1,RACE_DINOSAUR,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c100304021.tkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100304121,0,0x4011,0,0,1,RACE_DINOSAUR,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp) then
		local token=Duel.CreateToken(tp,100304121)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c100304021.tgcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,TYPE_TOKEN)
end
function c100304021.tglimit(e,c)
	return not c:IsType(TYPE_TOKEN)
end
function c100304021.repfilter(c,tp,e)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetFlagEffect(100304021)==0
end
function c100304021.desfilter(c,tp)
	return c:IsRace(RACE_DINOSAUR) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c100304021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c100304021.repfilter,nil,tp,e)
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(c100304021.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,ct,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(100304021,1)) then
		local g=eg:Filter(c100304021.repfilter,nil,tp,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c100304021.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,g:GetCount(),g:GetCount(),nil,tp)
		Duel.SetTargetCard(tg)
		local tc=tg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(100304021,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
			tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
			tc=tg:GetNext()
		end
		e:GetLabelObject():Clear()
		e:GetLabelObject():Merge(g)
		return true
	else return false end
end
function c100304021.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c100304021.repop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	while tc do
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
		tc=tg:GetNext()
	end
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end
