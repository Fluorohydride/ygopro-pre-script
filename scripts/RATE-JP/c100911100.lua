--ゾディアックS
--Zodiac Sign
--Script by nekrozar
function c100911100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1f2))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c100911100.atlimit)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c100911100.reptg)
	e5:SetValue(c100911100.repval)
	e5:SetOperation(c100911100.repop)
	c:RegisterEffect(e5)
end
function c100911100.atfilter(c,atk)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and c:GetAttack()>atk
end
function c100911100.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and Duel.IsExistingMatchingCard(c100911100.atfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c100911100.repfilter(c,tp,e)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x1f2) and c:IsReason(REASON_EFFECT) and c:GetFlagEffect(100911100)==0
end
function c100911100.desfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsType(TYPE_MONSTER)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c100911100.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100911100.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
		and eg:IsExists(c100911100.repfilter,1,nil,tp,e) end
	if Duel.SelectYesNo(tp,aux.Stringid(100911100,0)) then
		local g=eg:Filter(c100911100.repfilter,nil,tp,e)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c100911100.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
		Duel.HintSelection(tg)
		Duel.SetTargetCard(tg)
		tg:GetFirst():RegisterFlagEffect(100911100,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
		tg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c100911100.repval(e,c)
	return c==e:GetLabelObject()
end
function c100911100.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
